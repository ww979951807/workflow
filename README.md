## seatunnel build
apache/seatunnel
2.3.5
8
14
mvn clean spotless:apply package -pl seatunnel-dist -am -Dmaven.test.skip=true
seatunnel-dist/target
## dolphinscheduler build
apache/dolphinscheduler
3.2.2
8
16
mvn clean spotless:apply package -Prelease -Dmaven.test.skip=true -Dcheckstyle.skip=true -Dmaven.javadoc.skip=true
dolphinscheduler-dist/target

