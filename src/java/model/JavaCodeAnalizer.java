/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package model;

import java.util.List;
import model.test.ExecutionError;
import harsh.javatoxml.*;
import harsh.javatoxml.Exceptions.JXMLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.test.TestError;
import java.io.*;
import java.util.ArrayList;
import java.util.Vector;
import org.xml.sax.*;
import javax.xml.xpath.*;
import org.w3c.dom.*;
import model.test.TestedRoutine;


public class JavaCodeAnalizer extends CodeAnalizer {
    
    public void fixExecutionError( String code, String className, List<ExecutionError> l) {
        
        String xml = null;
        String result = "";
        
        try {
            result = Java2XML.java2XML(code, className );
        } catch (JXMLException ex) {
            return;
        }
        xml = result;
        
        XPath xpath = XPathFactory.newInstance().newXPath();
        String expression = "//constructor | //method";
        InputSource inputSource = new InputSource( new StringReader( xml ) );
        List<TestedRoutine> methodsFound = new ArrayList();
        try {
            NodeList constructorAndMethods = (NodeList) xpath.evaluate(expression, inputSource, XPathConstants.NODESET);
            for ( int i = 0; i < constructorAndMethods.getLength(); i++ ) {
                Node n = constructorAndMethods.item(i);

                boolean isMethod = n.getNodeName().equals( "method" );
                
                String params = "formal-arguments";
                Node arguments = (Node) xpath.evaluate(params, n, XPathConstants.NODE);
                    
                NodeList argumentList = arguments.getChildNodes();
                Vector<String> args = new Vector<String>();
                
//                for ( int c = 0; c < argumentList.getLength(); c++ )
//                    System.out.println( "formal-arguments/" + argumentList.item(c).getNodeName() + ": " + argumentList.item(c).getNodeValue() );
                
                for ( int z = 0; z < argumentList.getLength(); z++ ) {
                    
                    if ( argumentList.item(z).getNodeName().equals("formal-argument")) {
                        Node typeNode = null;
                        Node current = null;
                        int c = 0;
                        while ( (current = argumentList.item(z).getChildNodes().item( c )) != null ) {
                            if ( current.getNodeName().equals( "type" ) ) {
                                typeNode = current;
                                break;
                            }
                            c++;
                        }
                        
                        String arg = parseType( typeNode );
                        if ( arg != null ) {
                            args.add(arg);
                            
                        }
                    }
                }

                String line = n.getAttributes().getNamedItem("line").getNodeValue();
                String name = n.getAttributes().getNamedItem("name").getNodeValue();

                String routineType = "constructor";
                
                if ( isMethod ) routineType = "method";
                
                String strArg = "";
                for ( int y = 0; y < args.size(); y++ )
                    strArg += args.get(y) + " " ;
                
                TestedRoutine tm = new TestedRoutine( name, Integer.parseInt(line), args.toArray( new String[]{} ) );
                tm.setConstructor( !isMethod );
                methodsFound.add( tm );

            }
            
        } catch (XPathExpressionException ex) {
            Logger.getLogger(JavaCodeAnalizer.class.getName()).log(Level.SEVERE, null, ex);
            return;
        }
                
        /* fix execution errors */
        /* farlo pie' efficiente.. ha complessita' O(n2)*/
        for ( ExecutionError ee : l ) {
            TestedRoutine errorMethod = ee.getTestedRoutine();
            if ( errorMethod.getLine() == TestError.NO_LINE ) {
              /* se la linea c'è gia' vuol dire che e' un errore dato da una exception ( l'info e' piu' precisa cosi' come e' )*/
              for ( TestedRoutine tm : methodsFound ) {
                  if ( errorMethod.samePrototype( tm ) ) {
                      ee.setLineNumber( tm.getLine() );
                      break;
                  }
              }
            }
        }
        
    }
    
    private String parseType( Node start ) {
        
        if ( start == null || !start.getNodeName().equals("type")) return null;
        
        Node ntype = start.getAttributes().getNamedItem("name");
        if ( ntype == null )  return null;
        
        String type = ntype.getNodeValue();
        int dim;
        
        Node ndim = start.getAttributes().getNamedItem("dimensions");
        if ( ndim == null ) 
            dim = 0;
        else 
            dim = Integer.parseInt(ndim.getNodeValue() );

        for ( int i = 0; i < dim; i++ ) type += "[]";
        
        NodeList args = start.getChildNodes();
        
        Vector<String> v = new Vector<String>();
        
        for ( int i = 0; i < args.getLength(); i++ ) {
            if (args.item( i ).getNodeName().equals( "type-argument" )) {
                NodeList argumentList = args.item( i ).getChildNodes();
                
                Node typeNode = null;
                Node current = null;
                int c = 0;
                while ( (current = argumentList.item( c )) != null ) {
                    if ( current.getNodeName().equals( "type" ) ) {
                        typeNode = current;
                        break;
                    }
                    c++;
                }
                
                String singleType = parseType( typeNode );
                if ( singleType != null )
                    v.add( singleType );
            }
        }
        
        
        int vsize = v.size();
        
        if ( vsize == 0 ) 
            return type;
        
        type += "<";
        
        for ( int i = 0; i < vsize; i++ ) {
            type += v.get(i);
            if ( i < vsize - 1)  type += ",";
        }
        
        type += ">";
        
        return type;
        
    }
    
    
//    public static void main( String[] args ) {
//        
//        String code = "public class x { public void bobo() {} public void y( int a, List<String,List<String,List<Integer,Object[][]>>> variabili ) { } }";
//        
//        String result = "ERROR!! :-(";
//        
//        try {
//            result = Java2XML.java2XML(code, "x" );
//        } catch (JXMLException ex) {
//            return;
//        }
//        
//        System.out.println( result );
//        
//        List<ExecutionError> l = new ArrayList<ExecutionError>();
//        l.add( new ExecutionError( "y", "cdwd","dddddddddd", false, new String[] { "int", "List<String,List<String,List<Integer,Object[][]>>>" }  ) );
//        
//        new JavaCodeAnalizer().fixExecutionError(code, "x", l);
//        
//        System.out.println( l.get(0).getTestError().getLine() );
//    }

}
