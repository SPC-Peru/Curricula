import java.util.*;
import java.text.*;
import java.io.*;
public abstract class ParserCurricula{
	PrintStream out;
	int lnumber=0;
	String id;
	Vector<String> vTopics= new Vector<String>();

	public ParserCurricula(PrintStream out){this.out=out;}
	public String comillasInicio(){ return "``"; }
	public String comillasFin(){ return "\""; }
	public String interrogacionInicio(){ return "?´";}

	abstract public void showTitle(String id, String title);
	abstract public void showHours(String h);
	abstract public void showTopic(String tn, String desc, Vector<String> v);
	abstract public void showAllTopics(Vector<String> topics);
	abstract public void showObjective(String on, String desc);
	abstract public void showAllObjectives(int n);
	
	protected String numberToLetters(String num){
		String[] numberNames={"CERO","UNO","DOS","TRES","CUATRO","CINCO","SEIS","SIETE","OCHO","NUEVE","DIEZ","ONCE","DOCE","TRECE","CATORCE","QUINCE","DIECISEIS","DIECISIETE","DIECIOCHO","DIECINUEVE"};
		return numberNames[Integer.parseInt(num)];
	}
	public String withoutNumbers(String word){
		String[] s=word.split("[a-zA-Z]+");
		String num=s[1];
		assert num.matches("[0-9]+"): lnumber+": "+num+": "+s.length;

		int i=word.indexOf(num);

		return word.substring(0,i)+numberToLetters(num);

	}
	protected String withoutTags(String s){
		String[][] sa=getTags();
		for(int i=0;i<sa.length;i++){
			s=s.replaceAll(sa[i][0],sa[i][1]);
		}
		return s;
	}
	protected String withoutTildes(String s){
		String[][] sa=getChars();
		for(int i=0;i<sa.length;i++){
			s=s.replaceAll(sa[i][0],sa[i][1]);
		}
		return s;
	}
	protected String[][] getTags(){
		String [][] result={{"\\\\[a-zA-Z]+\\{",""}};
		return result;
	}

/*	protected String[][] getStrings(){
		return {{"\\'a","á"},{"\\'e","é"},{"\\'i","á"},{"\\'a","á"},
			{"\\'a","á"},{"\\'a","á"},{"\\'a","á"},{"\\'a","á"},
			{"\\'a","á"},{"\\'a","á"},{"\\'a","á"},{"\\'a","á"},
			{"\\[a-z]+{",""}};
	}
*/
	protected String[][] getChars(){
		String[][] c= {{"á","a"},{"é","e"},{"í","i"},{"ó","o"},
			{"ú","u"},{"ñ","n"},
			{"Á","A"},{"É","E"},{"Í","I"},
			{"Ú","U"},{"Ñ","N"},
			{"\\{",""},{"\\}",""},{"\\\\",""},{"\'",""}};
		return c;
	}

	protected String parseDesc(String s){
/*		char [][]c=getChars();
		String[][] s=getStrings();
		
		for(int i=0;i<s.length;i++)
			desc=desc.replaceAll(s[i][0],s[i][1]);

		for(int i=0;i<c.length;i++)
			desc=desc.replace(c[i][0],c[i][1])
		
		return desc;*/
		String rpta="";

		//Comillas
		String []r=s.split("\"");
		if(r.length>1){
			for(int i=0;i<r.length;i+=3){
				rpta+=r[i]+
					comillasInicio()+r[i+1]+
					comillasFin()+r[i+2];
			}
		}else 
			rpta=r[0];
		
		//¿
		rpta=rpta.replaceAll("¿",interrogacionInicio()).trim() + ". ";

		
		return rpta;
		
	}
	protected String onlyChars(String s){
		String result="";
		for(int i=0;i<s.length();i++){
			String character=s.substring(i,i+1);
			if(character.matches("[a-zA-Z]"))
				result+=character;
		}
		return result;
	}
	protected String topicName(String s, int n){
		String result="";
		String[] sa=s.trim().split("[^a-zA-ZáéíóúÁÉÍÓÚñÑ]");
		for(int i=0;i<n;i++){
			result+=sa[i];
		}
		assert(!result.equals("")): lnumber+": "+sa.length+":"+s ;
		return result;
	}

	public void procesaTituloTema(String line){
		String[]s=line.split("[: \\.]+",3);
		assert s[0].equals("Nombre"): lnumber;
		assert s[1].matches("[A-Z]{2}[0-9]{1,2}"): lnumber;

		id=s[1];
		String title=s[2].trim();

		showTitle(id,title);
	}

/*	public char[][] replaceChar(){
		char[][] array = {{'á','é','í','ó','ú','Á','É','Í','Ó','Ú',''
	}
*/
	public void procesaHorasTema(String s){
		String[] as=s.split("[:\\s]+");
		String horas=as[1].trim();
		assert horas.matches("[0-9]+"): lnumber + ": "+horas;

		showHours(horas);
	}
	public String procesaTopico(String s, Vector<String> st){
		int i=1;
		String sn=withoutTildes(withoutTags(s));
		String tn=topicName(sn,i);
		while(vTopics.contains(id+tn)){
			i++;
			tn=topicName(sn,i);
		}
		vTopics.addElement(id+tn);
		showTopic(tn,parseDesc(s),st);
		return tn;
	}
	public void procesaObjetivo(String s){
		String[] as=s.split("\\.-",2);
		String number=as[0].trim();
		String desc=as[1].trim();
		assert(number.matches("[0-9]+")): lnumber+" :"+number+": "+s;
		showObjective(number,parseDesc(desc));
	}
	public String procesaSubTopico(String s){
		if(s.matches("^[\\s]*-[\\s]*.+$")){
			s=s.trim();
			s=s.substring(1).trim();
		}
		assert(!s.matches("^[\\s]*-[\\s]*.+$")): lnumber+": "+s;
		return s;
	}
	public Vector<String> procesaSubTopicos(BufferedReader in)throws IOException{
		String l=in.readLine();
		lnumber++;
		Vector<String> v=new Vector<String>();
		while(!l.matches("^[\\s]*[(]fin_sub_topico[)][\\s]*$")){
			if(!l.matches("^[\\s]*$"))
				v.addElement(procesaSubTopico(l));
			l=in.readLine();
			assert(l!=null): lnumber;
			lnumber++;
		}
		return v;
	}
	private boolean lockAhead(BufferedReader in,String s){
		int readAheadLimit=s.length()*2;
		try{
			in.mark(readAheadLimit);
			char[] buffer=new char[readAheadLimit+1];
			int n=in.read(buffer,0,readAheadLimit);
			in.reset();
			String line=new String(buffer);
			String[] as=line.split("\n|(\n\r)");
			line=as[0].trim();
//			System.err.println(as.length+":"+line.matches("^[(][\\s]*"+s+"[\\s]*[)]")+":"+line+":");
			if(line.matches("[.]*[(][\\s]*"+s+"[\\s]*[)]")){
				in.readLine();
				lnumber++;
				return true;
			}
		}catch (IOException e){
			System.err.println("Error en lockAhead: "+e);
			System.exit(1);
		}
		return false;
	}
	public Vector<String> procesaTopicos(BufferedReader in)throws IOException{
		Vector<String> topics=new Vector<String>();
		String l=in.readLine();
		lnumber++;
		while(!l.matches("^[\\s]*[(]fin_topico[)][\\s]*$")){
			if(!l.matches("^[\\s]*$")){
				Vector<String> st=new Vector<String>();
				if(lockAhead(in,"inicio_sub_topico"))
					st=procesaSubTopicos(in);
				topics.add(procesaTopico(l,st));
			}
			l=in.readLine();
			lnumber++;
		}
		return topics;
	}
	public int procesaObjetivos(BufferedReader in)throws IOException{
		int objectives=0;
		String l=in.readLine();
		lnumber++;
		while(!l.matches("^[\\s]*[(]fin_objetivo[)][\\s]*$")){
			if(!l.matches("^[\\s]*$")){
				assert(l.matches("[0-9]+\\.-.+")):lnumber+": "+l;
				procesaObjetivo(l);
				objectives++;
			}
			l=in.readLine();
			lnumber++;
		}
		return objectives;
	}
	public void finalizaApendice(){
	}
	public void parser(BufferedReader in) throws IOException{
		String l=in.readLine();
		lnumber++;
		while(l!=null){
			if(l.matches("^Nombre[\\s]*:[\\s]*[A-Z][A-Z][0-9].+"))
				procesaTituloTema(l);
			else if(l.matches("^Horas[\\s]*:[\\s]*[0-9]+[\\s]*$"))
				procesaHorasTema(l);
			else if(l.matches("^[\\s]*[(]inicio_topico[)][\\s]*$")){
				finalizaApendice();
				Vector<String> topics=procesaTopicos(in);
				showAllTopics(topics);
			}else if(l.matches("^[\\s]*[(]inicio_objetivo[)][\\s]*$")){
				int objectives=procesaObjetivos(in);
				showAllObjectives(objectives);
			}else if(!l.matches("[\\s]*") && 
					!l.matches("[\\s]*Objetivos[\\s]*[:]+[\\s]*") &&
					!l.startsWith("Objetivos") &&
					!l.matches("[\\s]*T[óo]picos[\\s]*[:]?[\\s]*")){
				System.err.println("Error en la línea: "+
						lnumber);
				System.err.println(l);
				System.exit(1);
			}
			l=in.readLine();
			lnumber++;
		}
	}
}
