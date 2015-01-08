import java.util.*;
import java.io.*;
import javax.imageio.stream.*;
class ToApendice extends ParserCurricula{
	int[] areasHoras={6,5,11,9,12,9,11,8,11,10,14,10,12,3};
	String[] areasDesc= {"DS. Estructuras Discretas",
		"PF. Fundamentos de Programación",
		"AL. Algoritmos y Complejidad",
		"AR. Arquitectura y Organización",
		"OS. Sistemas Operativos",
		"NC. Computación Centrada en Redes",
		"PL. Lenguajes de Programación",
		"HC. Interacción Humano Computador",
		"GV. Computación Gráfica y Visual",
		"IS. Sistemas Inteligentes",
		"IM. Administración de la Información",
		"SP. Asuntos Sociales y Profesionales",
		"SE. Ingeniería del Software",
		"CN. Ciencia Computacional y Métodos Numéricos"};
	String previousArea="";
	String finalApendice="";
	String horas= "";
	public ToApendice(PrintStream out){ super(out); }
	String getCurrentArea(){
		return id.substring(0,2);
	}
	int getIDAreas(String idArea){
		String result;
		int i=0;
		for(;i<areasDesc.length &&
				!areasDesc[i].startsWith(idArea);i++);
		assert(i<areasDesc.length): idArea;
		return i;
	}
	
	public void showTitle(String id, String title){
		if(!previousArea.equals(getCurrentArea())){
			previousArea=getCurrentArea();
			int idArea=getIDAreas(previousArea);
			try{
			out.println("\n\\section{"+areasDesc[idArea]+
					"}\\label{sec:BOK-"+previousArea+"}");
			}catch(ArrayIndexOutOfBoundsException e){
				System.err.println(e+":"+idArea+"<"+
						areasDesc.length);
				System.exit(1);
			}
		}
		horas=" (\\"+withoutNumbers(id)+"Hours horas)";

		finalApendice="}\\label{sec:BOK-"+id+"}";
		out.print("\n\\subsection{\\"+withoutNumbers(id)+
				"Def ");
				//+"(\\"+withoutNumbers(id)
				//+"Hours horas)}\\label{sec:BOK-"+id+"}");
	}
	public void finalizaApendice(){
		out.println(finalApendice);
	}
	public void showHours(String h){
		out.print(horas);
	}
	public void showTopic(String tn, String desc, Vector<String> v){}
	public void showAllTopics(Vector<String> topics){
		out.println("\n\\textbf{Tópicos}\n\\begin{itemize}");
		for(Enumeration e = topics.elements();e.hasMoreElements();)
			out.println("\t\\item \\"+withoutNumbers(id)+
					"Topic"+e.nextElement());
		out.println("\\end{itemize}");
	}
	public void showObjective(String on, String desc){}
	public void showAllObjectives(int n){
		out.println("\n\\textbf{Objetivos}\n\\begin{itemize}");
		for(int i=0;i<n;i++){
			String number=""+(i+1);
			out.println("\t\\item \\"+withoutNumbers(id)+
					"Obj"+numberToLetters(number));
		}
		out.println("\\end{itemize}");
	}
	public void showIndice(PrintStream output){
//		output.println("\\twocolumn[\\begin{center}\\begin{Large}\\textbf{Cuerpo del Conocimiento}\\end{Large}\\end{center}]");
		output.println("\\noindent%");
		for(int i=0; i<areasDesc.length;i++){
			String area=areasDesc[i];
			output.print("\t\\textbf{"+area.substring(0,3)+"} ");
			output.println(area.substring(3)+"%");
			output.println("\t\\begin{list}{}{%");
			output.println("\t\t\\setlength{\\labelwidth}{0pt}%");
			output.println("\t\t\\setlength{\\leftmargin}{15pt}}%");
			for(int j=0;j<areasHoras[i];j++){
				String number=""+(j+1);
				String aid=area.substring(0,2);
				output.println("\t\t\\item \\"+aid+
						numberToLetters(number)+"Def (Pág. \\pageref{sec:BOK-"+aid+number+"})");

			}
			output.println("\t\\end{list}%");
		}
//		output.println("\\onecolumn");
	}
	public static void main(String[] arg) throws IOException{
		PrintStream  tmp = new PrintStream("tmp.txt");
		BufferedReader in
			= new BufferedReader(new InputStreamReader(System.in));
		ToApendice ta2=new ToApendice(tmp);
		ta2.parser(in);
		tmp.close();

		PrintStream out = new PrintStream("cs-bok-body.tex");
		FileImageInputStream in2 = new FileImageInputStream(new File("tmp.txt"));
		ta2.showIndice(out);
		cat(in2,out);
		in2.close();
		out.close();
	}
	public static void cat(FileImageInputStream in, PrintStream out) throws IOException{
		String line = in.readLine();
		while(line != null){
			out.println(line);
			line = in.readLine();
		}
	}

}
