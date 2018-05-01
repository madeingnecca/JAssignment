/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package tag;

import model.*;

public class Common {
    private Common() {
        
    }
    
    static final int             OK = 0;
    static final int             KO = 1;
    static final int             SUBMITTED = 2;
    static final int             NOT_SUBMITTED = 3;
    static final int             NOT_REQUESTED = 4;
    static final int             NONE = 5;
    static final int             NOT_TESTED = 6;
    static final int             HUMAN_NEEDED = 7;
    
    static int getPartial ( int oldP, int newP ) {
        int partial = newP;
        
        if ( oldP == KO || newP == KO )
            partial = KO;
        else if ( oldP == NOT_TESTED || newP == NOT_TESTED )
            partial = NOT_TESTED;
        else if ( oldP == HUMAN_NEEDED || newP == HUMAN_NEEDED ) 
            partial = HUMAN_NEEDED;
        else if ( oldP == NOT_SUBMITTED || newP == NOT_SUBMITTED ) 
            partial = NOT_SUBMITTED;
        
        return partial;
    }

    static int[] getResults( Student stud, Text txt , int astate ) {
        
        int[] res = new int[ 4 ];
        
        Assignment current = txt.getAssignment();
        boolean tested = current.isCorrected();
        
        int esitoCompilazione = NONE;
        int esitoEsecuzione = NONE;
        int esitoPseudocode = NONE;
        int state = OK;
        
        boolean open = ( Assignment.isOpen(state) );
        Submission consegna = (Submission) stud.getSubmissions().get( txt );
        
        if ( !open ) {
            if (!tested) {
                if (consegna == null) {
                    /* non ho consegnato quell'es.. */
                    esitoCompilazione = NOT_SUBMITTED;
                    esitoEsecuzione = NOT_SUBMITTED;
                    if ( txt.isPseudocodeRequested() ) 
                        esitoPseudocode = NOT_SUBMITTED;
                    state = NOT_SUBMITTED;
                }
                else {
                    esitoCompilazione = SUBMITTED;
                    esitoEsecuzione = SUBMITTED;
                    if ( txt.isPseudocodeRequested() ) 
                        esitoPseudocode = SUBMITTED;
                    state = SUBMITTED;
                }
            } else {

                if ( consegna == null ) {
                    esitoCompilazione = KO;
                    esitoEsecuzione = KO;
                    esitoPseudocode = KO;
                    state = KO;
                }
                else {
                    consegna.setText(txt);
                    consegna.setLogin(stud);
                    
                    Result result = consegna.getResult();
                    
                    if ( result == null ) {
                        /* misteriosamente non c'e il risultato della consegna */
                        esitoCompilazione = NOT_TESTED;
                        esitoEsecuzione = NOT_TESTED;
                        esitoPseudocode = NOT_TESTED;
                        state = NOT_TESTED;
                    }
                    else 
                    {
                        int  rc = result.getReturnCode();
                        switch ( rc ) {
                            case Result.NOT_TESTED: {
                                break;
                            }
                            case Result.COMPILES_KO: {
                                esitoCompilazione = KO;
                                esitoEsecuzione = KO;
                                state = KO;
                                break;
                            }
                            case Result.COMPILES_OK: {
                                
                                if ( txt.isHumanNeeded() ) {
                                    esitoCompilazione = OK;
                                    esitoEsecuzione = HUMAN_NEEDED;
                                    state = HUMAN_NEEDED;
                                } else {
                                    esitoCompilazione = OK;
                                    esitoEsecuzione = NOT_TESTED;
                                    state = NOT_TESTED;
                                } 
                                
                                break;
                            }
                            case Result.EXECUTES_KO: {
                                esitoCompilazione = OK;
                                esitoEsecuzione = KO;
                                state = KO;
                                break;
                            }
                            case Result.EXECUTES_OK: {
                                esitoCompilazione = OK;
                                esitoEsecuzione = OK; 
                                state = OK;
                                break;
                            }
                        }
                        
                        if ( txt.isPseudocodeRequested() ) {
                            Boolean pseudook = result.isPseudoOk();

                            if ( pseudook != null ) {
                                if ( pseudook ) 
                                    esitoPseudocode = OK;
                                else {
                                    state = KO;
                                    esitoPseudocode = KO;
                                }
                            }
                            else {
                                esitoPseudocode = HUMAN_NEEDED;
                                if ( state == OK ) 
                                    state = HUMAN_NEEDED;
                            }
                        }
                    }
                 }
            }
        }
        else {
            if (consegna == null) {
                /* non ho consegnato quell'es.. */
                state = NOT_SUBMITTED;
            }    
            else state = SUBMITTED;
        }
        
        res[ 0 ] = esitoCompilazione;
        res[ 1 ] = esitoEsecuzione;
        res[ 2 ] = esitoPseudocode;
        res[ 3 ] = state;
        return res;
    }
    
}
