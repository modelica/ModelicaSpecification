export CLASSPATH=.:$CLASSPATH
make Modelica.g4
# Test as ANTLR3 grammar; checking k<=2
java org.antlr.Tool -Xconversiontimeout 10000 -report Modelica.g || exit 1
java -Xmx500M org.antlr.v4.Tool Modelica.g4 || exit 1
javac -g *.java || exit 1
# java -Xmx500M org.antlr.v4.gui.TestRig Modelica stored_definition -tokens test.mo || exit 1
java -Xmx500M org.antlr.v4.gui.TestRig Modelica stored_definition $1 test.mo || exit 1
