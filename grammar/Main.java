import java.io.IOException;
import java.io.InputStream;
import java.io.FileInputStream;

import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.TokenStream;


class Main {
   public static void main(String[] args) {
      try {
         System.out.println(args[1]);
         InputStream inputStream = new FileInputStream(args[1]);
         Lexer lexer = new ModelicaLexer(CharStreams.fromStream(inputStream));
         TokenStream tokenStream = new CommonTokenStream(lexer);
         ModelicaParser parser = new ModelicaParser(tokenStream);
         parser.stored_definition();
         if (parser.getNumberOfSyntaxErrors() > 0) {
           System.exit(1);
         }
      } catch (IOException e) {
         e.printStackTrace();
      }
   }
}
