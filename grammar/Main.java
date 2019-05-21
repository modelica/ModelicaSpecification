import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.FileInputStream;

import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.TokenStream;


class Main {
public static void parseFile(Path path) {
  try {
    InputStream inputStream = new FileInputStream(path.toFile());
    Lexer lexer = new ModelicaLexer(CharStreams.fromStream(inputStream));
    TokenStream tokenStream = new CommonTokenStream(lexer);
    ModelicaParser parser = new ModelicaParser(tokenStream);
    parser.stored_definition();
    if (parser.getNumberOfSyntaxErrors() > 0) {
      System.out.println("Error parsing file " + path.toString());
      System.exit(1);
    }
    return;
  } catch (IOException e) {
    e.printStackTrace();
  }
  System.exit(1);
}

public static void main(String[] args) throws IOException {
  Files.walk(Paths.get(args[0]))
  .filter(file -> (Files.isRegularFile(file) && file.toString().endsWith(".mo")))
  .forEach(Main::parseFile);
  System.exit(0);
}
}
