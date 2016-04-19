# 2.1.0
  - Depend on logstash-mixin-zeromq, remove lib/logstash/util/zeromq
  - Adapt test usage to be friendly with the way we run LS core default plugins test
  - Fix plugin consumes 100% cpu
# 2.0.4
  - Depend on logstash-core-plugin-api instead of logstash-core, removing the need to mass update plugins on major releases of logstash
# 2.0.3
  - New dependency requirements for logstash-core for the 5.0 release
## 2.0.0
 - Plugins were updated to follow the new shutdown semantic, this mainly allows Logstash to instruct input plugins to terminate gracefully,
   instead of using Thread.raise on the plugins' threads. Ref: https://github.com/elastic/logstash/pull/3895
 - Dependency on logstash-core update to 2.0

# 1.1.0
  - Add basic test to the project
