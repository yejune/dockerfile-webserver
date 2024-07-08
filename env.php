<?php

class ExtensionVersionFetcher
{
    private $extensionsMap;
    private $maxAttempts;
    private $maxConcurrent;

    public function __construct($maxAttempts = 5, $maxConcurrent = 5)
    {
        $this->extensionsMap = [
            'PHALCON' => 'phalcon', 'SWOOLE' => 'swoole', 'UUID' => 'uuid', 'APFD' => 'apfd',
            'JSONPOST' => 'json_post', 'YAML' => 'yaml', 'JSONNET' => 'jsonnet', 'PROTOBUF' => 'protobuf',
            'IGBINARY' => 'igbinary', 'MSGPACK' => 'msgpack', 'MAILPARSE' => 'mailparse', 'BASE58' => 'base58',
            'APCU' => 'apcu', 'APCU_BC' => 'apcu_bc', 'MEMCACHED' => 'memcached', 'REDIS' => 'redis',
            'MONGODB' => 'mongodb', 'RDKAFKA' => 'rdkafka', 'SIMPLE_KAFKA_CLIENT' => 'simple_kafka_client',
            'VAR_REPRESENTATION' => 'var_representation', 'JSONPATH' => 'jsonpath', 'COUCHBASE' => 'couchbase',
            'CASSANDRA' => 'cassandra', 'AMQP' => 'amqp', 'GEARMAN' => 'gearman', 'SODIUM' => 'libsodium',
            'MCRYPT' => 'mcrypt', 'UV' => 'uv', 'EIO' => 'eio',
            'EVENT' => 'event', 'MEMPROF' => 'memprof', 'HTTP' => 'pecl_http',
            'DECIMAL' => 'decimal', 'IMAGICK' => 'imagick', 'VIPS' => 'vips', 'SSH2' => 'ssh2',
            'SQLSRV' => 'sqlsrv', 'V8JS' => 'v8js', 'V8' => 'v8', 'OAUTH' => 'oauth',
            'XLSWRITER' => 'xlswriter', 'XDEBUG' => 'xdebug', 'SEASLOG' => 'seaslog', 'COMPONERE' => 'componere', 
            'VLD' => 'vld', 'DATADOG_TRACE' => 'datadog_trace', 'GRPC' => 'grpc',
            'PSR' => 'psr', 'YACONF' => 'yaconf', 'HTTP_MESSAGE' => 'http_message', 'WASM' => 'wasm',
            'ZEPHIR_PARSER' => 'zephir_parser', 'ZEPHIR' => 'zephir-lang/zephir',
            'GEOSPATIAL' => 'geospatial', 'EXCIMER' => 'excimer', 'AWSCRT' => 'awscrt', 'ZOOKEEPER' => 'zookeeper', 
            'XHPROF' => 'xhprof', 'UOPZ' => 'uopz', 'SIMDJSON' => 'simdjson', 'BSDIFF' => 'bsdiff', 'SOLR' => 'solr',
            // 'RUNKIT7' => 'runkit7', 'SCREWIM' => 'screwim', 'CALLEE' => 'callee', 'EXCEL' => 'excel', 'EV' => 'ev'
        ];
        $this->maxAttempts = $maxAttempts;
        $this->maxConcurrent = $maxConcurrent;
    }

    public function fetchAllVersions()
    {
        $attempt = 1;
        $failedExtensions = $this->extensionsMap;

        while ($attempt <= $this->maxAttempts && !empty($failedExtensions)) {
            if ($attempt > 1) {
                echo "# Retry attempt {$attempt}\n";
            }

            $nextFailedExtensions = [];

            $peclExtensions = array_filter($failedExtensions, function($alias) {
                return $alias !== 'ZEPHIR';
            }, ARRAY_FILTER_USE_KEY);

            $peclResults = $this->getLatestVersionFromPecl($peclExtensions);

            foreach ($failedExtensions as $alias => $realName) {
                if ($alias === 'ZEPHIR') {
                    $version = $this->getLatestVersionFromGitHubWeb($realName);
                } else {
                    $version = $peclResults[$realName] ?? "";
                }

                if ($version) {
                    echo "EXTENSION_{$alias}_VERSION={$version}\n";
                } else {
                    $nextFailedExtensions[$alias] = $realName;
                }
            }

            $failedExtensions = $nextFailedExtensions;
            $attempt++;
        }

        foreach ($failedExtensions as $alias => $realName) {
            echo "ARG EXTENSION_{$alias}_VERSION=\n";
        }
    }

    private function getLatestVersionFromPecl($extensions)
    {
        $multiHandle = curl_multi_init();
        $curlHandles = [];
        $results = [];
        $running = 0;
        $queue = $extensions;

        while (!empty($queue) || $running > 0) {
            for ($i = $running; $i < $this->maxConcurrent && !empty($queue); $i++) {
                $extension = array_shift($queue);
                $url = "https://pecl.php.net/package/" . $extension;
                $ch = curl_init();
                curl_setopt($ch, CURLOPT_URL, $url);
                curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
                curl_setopt($ch, CURLOPT_TIMEOUT, 30);
                curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0');
                curl_multi_add_handle($multiHandle, $ch);
                $curlHandles[$extension] = $ch;
                $running++;
            }

            do {
                $status = curl_multi_exec($multiHandle, $running);
            } while ($status === CURLM_CALL_MULTI_PERFORM);

            if ($running > 0) {
                curl_multi_select($multiHandle);
            }

            while ($done = curl_multi_info_read($multiHandle)) {
                $extension = array_search($done['handle'], $curlHandles);
                $html = curl_multi_getcontent($done['handle']);
                curl_multi_remove_handle($multiHandle, $done['handle']);
                curl_close($done['handle']);
                unset($curlHandles[$extension]);
                $running--;

                if ($html === false || empty($html)) {
                    $results[$extension] = "";
                    echo "# Failed to fetch data for $extension\n";
                    continue;
                }

                $dom = new DOMDocument();
                libxml_use_internal_errors(true);
                $dom->loadHTML($html);
                libxml_clear_errors();

                $xpath = new DOMXPath($dom);
                $versionNode = $xpath->query("//tr[th[contains(text(),'Version')]]/following-sibling::tr[1]/th/a");

                if ($versionNode->length > 0) {
                    $version = str_replace('&period;', '.', $versionNode->item(0)->textContent);
                    // if (preg_match('/^\d+\.\d+\.\d+$/', $version)) {
                        $results[$extension] = $version;
                        continue;
                    //}
                }

                $results[$extension] = "";
            }
        }

        curl_multi_close($multiHandle);

        return $results;
    }
    private function getLatestVersionFromGitHubWeb($repo)
    {
        $url = "https://github.com/" . $repo;
        
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_TIMEOUT, 30);
        curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36');
        
        $html = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
    
        if ($html === false || $httpCode !== 200) {
            echo "# Failed to fetch data from GitHub for $repo. HTTP Code: $httpCode\n";
            return "";
        }
    
        $dom = new DOMDocument();
        @$dom->loadHTML($html);
        $xpath = new DOMXPath($dom);
    
        $versionQuery = "//a[contains(@class, 'Link--primary') and contains(@href, '/releases/tag/')]//span[contains(@class, 'css-truncate-target')]";
        $versionNodes = $xpath->query($versionQuery);
    
        if ($versionNodes->length > 0) {
            $version = trim($versionNodes->item(0)->textContent);
            $version = preg_replace('/^v/', '', $version);  // Remove leading 'v' if present
            if (preg_match('/^\d+\.\d+\.\d+/', $version, $matches)) {
                return $matches[0];  // Return only X.Y.Z part
            }
        }
    
        echo "# No valid version found for $repo. HTML structure might have changed.\n";
        return "";
    }
}
echo "#!make".PHP_EOL.PHP_EOL;
// 사용 예:
$fetcher = new ExtensionVersionFetcher();
$fetcher->fetchAllVersions();