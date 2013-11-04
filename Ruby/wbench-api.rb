require 'wbench'
# https://github.com/desktoppr/wbench

addrs = \w{''}
data = {}

each addrs {|addr|
  benchmark = WBench::Benchmark.new(addr, :browser => :chrome)
  results   = benchmark.run(3) # => WBench::Results
  each results.browser {|item|
  }
}



results.app_server # =>
  [25, 24, 24]

 # =>
  {
    "navigationStart"            => [0, 0, 0],
    "fetchStart"                 => [0, 0, 0],
    "domainLookupStart"          => [0, 0, 0],
    "domainLookupEnd"            => [0, 0, 0],
    "connectStart"               => [12, 12, 11],
    "connectEnd"                 => [609, 612, 599],
    "secureConnectionStart"      => [197, 195, 194],
    "requestStart"               => [609, 612, 599],
    "responseStart"              => [829, 858, 821],
    "responseEnd"                => [1025, 1053, 1013],
    "domLoading"                 => [1028, 1055, 1016],
    "domInteractive"             => [1549, 1183, 1136],
    "domContentLoadedEventStart" => [1549, 1183, 1136],
    "domContentLoadedEventEnd"   => [1549, 1184, 1137],
    "domComplete"                => [2042, 1712, 1663],
    "loadEventStart"             => [2042, 1712, 1663],
    "loadEventEnd"               => [2057, 1730, 1680]
  }

results.latency # =>
  {
    "a.desktopprassets.com"         => [352, 15, 15],
    "beacon-1.newrelic.com"         => [587, 235, 248],
    "d1ros97qkrwjf5.cloudfront.net" => [368, 14, 14],
    "ssl.google-analytics.com"      => [497, 14, 14],
    "www.desktoppr.co"              => [191, 210, 203]
  }