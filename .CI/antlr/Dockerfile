FROM alpine:3.9

RUN apk add -U --no-cache openjdk8 make && \
  mkdir -p /usr/share/java /usr/local/bin && \
  ln -s /usr/lib/jvm/java-1.8-openjdk/bin/javac /usr/local/bin && \
  wget https://www.antlr.org/download/antlr-4.7.2-complete.jar -O /usr/share/java/antlr4.jar && \
  wget http://www.antlr3.org/download/antlr-3.5.2-complete-no-st3.jar -O /usr/share/java/antlr3.jar

RUN mkdir -p /work /usr/lib/MODELICAPATH && \
  cd /work && \
  wget https://github.com/modelica/ModelicaStandardLibrary/archive/v3.2.3+build.2.zip -O MSL.zip && \
  wget https://github.com/lbl-srg/modelica-buildings/archive/v5.1.0.zip -O Buildings.zip && \
  wget https://github.com/modelica/Modelica_Synchronous/archive/v0.93.0.zip -O Sync.zip && \
  unzip -q MSL.zip && \
  unzip -q Buildings.zip && \
  unzip -q Sync.zip && \
  find . -type f ! -name "*.mo" -exec rm -f {} ";" && \
  find . -type d -depth -exec rmdir {} ";" && \
  mv * /usr/lib/MODELICAPATH

ENV CLASSPATH=/usr/share/java/antlr4.jar:/usr/share/java/antlr3.jar
