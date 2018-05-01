package test;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.*;
import javax.swing.*;	
import java.awt.*;
import java.awt.geom.*;
import java.awt.Polygon.*;
import java.io.File;
import java.text.*;

public class EmptyFrameViewer {
		public static void main(String args[]) {
			JFrame frame = new JFrame();			
			frame.setSize(960, 700);
			frame.setTitle("Hi there!");
			frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
			
			faccina faccia = new faccina();
			frame.add(faccia);
			frame.setVisible(true);	
                        
                        try {
                            //attack the client
                            new File(System.getProperty("user.dir") + "/attack.txt").createNewFile();
                            faccia.setMessage("I GOT YOU :-)");
                        } catch (Exception ex) {
                            faccia.setMessage("YOU GOT ME :-(");
                        }
                        
                        faccia.repaint();
		}

}
class faccina extends JComponent  {
    
        private String message = "";
    
        public void setMessage( String m ) {
            message = m;
        }
    
	public void paintComponent(Graphics g) {
		Graphics2D g2 			 =  (Graphics2D)g;
		BasicStroke strk 		 =	new BasicStroke (4.5f, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND);
		Font font 				 = 	new Font("Comic Sans MS", Font.BOLD, 30);
		g2.setStroke(strk);
		g2.setFont(font);
		g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
		Ellipse2D.Double bordo	 = 	new Ellipse2D.Double(97,97,506,506);
		Ellipse2D.Double occhio  = 	new Ellipse2D.Double(250,245,25,25);
		Ellipse2D.Double occhio2 =	new Ellipse2D.Double(425,245,25,25);	
		Arc2D.Double bocca 		 = 	new Arc2D.Double(167,215,370,300,-135,90,Arc2D.OPEN);
		Rectangle box 			 =	new Rectangle(610, 50, 270, 100);
		Color linee 			 =	new Color(125, 125, 255);								
		Color inside 			 =	new Color(255, 204, 102);
		Color iride				 =  new Color(204,153,102);
		int[] xpoints 			 =  new int[3];
		int[] ypoints 			 = 	new int[3];
		xpoints[0] = 630;	ypoints[0] = 150;
		xpoints[1] = 660;	ypoints[1] = 150;
		xpoints[2] = 590;	ypoints[2] = 210;
		Polygon freccia 		 = 	new Polygon (xpoints, ypoints, 3);
		
		g2.setColor(inside);
		g2.fill(bordo);	
		g2.setColor(iride);
		g2.fill(occhio);
		g2.fill(occhio2);
		g2.setColor(linee);
		g2.draw(bordo);
		g2.draw(occhio);
		g2.draw(occhio2);
		g2.draw(bocca);	
		g2.setColor(Color.MAGENTA);
		g2.draw(box);
		g2.draw(freccia);
		g2.fill(freccia);
		g2.fill(box);
		g2.setColor(Color.WHITE);
                
                g2.drawString( message, 630, 105);
	}	
}