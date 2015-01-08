import java.io.*;
import java.util.*;
class ToLatex extends ParserCurricula{

	ToLatex(PrintStream out){ super(out); }
	
	public String comillasInicio(){ return "``"; }
	public String comillasFin(){ return "\""; }
	public String interrogacionInicio(){ return "?´";}

	public void showTitle(String id, String title){
		out.println("\n\\newcommand{\\"+withoutNumbers(id)+
				"Def}{"+id+". "+parseDesc(title)+ "}");
	}
	public void showHours(String h){
		out.println("\\newcommand{\\"+withoutNumbers(id)+
				"Hours}{"+h+"}");
	}
	public void showTopic(String tn, String desc, Vector<String> v){
		out.print("\\newcommand{\\"+withoutNumbers(id)+
				"Topic"+tn+"}{"+desc);
		if(v.size()>0){
			out.println("\n\t\\begin{inparaenum}[ a)]%");
			for(Enumeration e = v.elements(); e.hasMoreElements();)
				out.println("\t\t\\item "+e.nextElement()+
					". %");
			out.println("\t\\end{inparaenum}%");
			
		}
		out.println("}");
	}
	public void showAllTopics(Vector<String> topics){
		out.println("\\newcommand{\\"+withoutNumbers(id)+
				"AllTopics}%\n{%\n\\begin{topicos}%");
		for(Enumeration e = topics.elements(); e.hasMoreElements();)
			out.println("\\item \\"+withoutNumbers(id)+
					"Topic"+e.nextElement()+"%");
		out.println("\\end{topicos}%\n}");
	}
	public void showObjective(String on, String desc){
		out.println("\\newcommand{\\"+withoutNumbers(id)+"Obj"+
				numberToLetters(on)+"}{"+desc+"}");
	}
	public void showAllObjectives(int n){
		out.println("\\newcommand{\\"+withoutNumbers(id)+
				"AllObjectives}%\n{%\n\\begin{objetivos}%");
		for(int i=0;i<n;i++){
			String number=""+(i+1);
			out.println("\\item \\"+withoutNumbers(id)+"Obj"+
					numberToLetters(number)+"%");
		}
		out.println("\\end{objetivos}%\n}");
	}
	public static void main(String[] arg) throws IOException{
		BufferedReader in
			= new BufferedReader(new InputStreamReader(System.in));
		ToLatex pc=new ToLatex(System.out);
		pc.parser(in);
	}

}
