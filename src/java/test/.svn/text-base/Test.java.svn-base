package test;

import java.util.ArrayList;
import java.util.List;

public class Test extends test.ClassicTestCase {

    public static int trustedSum( List<Integer> l ) {
        
        int s = 0;
        for ( Integer i : l ) {
            s += i;
        }
        
        return s;
    }
    
    public void test() {
        
        int a[] = new int[] { 1,2,3,4,5,6 };
        List<Integer> l = new ArrayList<Integer>();

        for ( int i = 0; i < a.length; i++ )
            l.add( a[i] );
        
        if ( new Consegna().sum(l) != Test.trustedSum(l)) {
            this.raiseMethodError("sum","t1", "sum != trustedsum", "List<Integer>");
        }
        
    }
    
    
}

