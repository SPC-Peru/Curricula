#include<iostream>
#include<string>
#include<list>
#include<vector>

using namespace std;

#define nc "\\newcommand{\\"

main(){
	string line;
	char buffer[1024
	getline(cin,line);
	cin.getline(buffer,1024);
	line=buffer;	
	while(line=="#"){
		string title=line;
		
		//vector<string> topicsID;
		
		cin>>line;
		while(line!=""){
			int i= line.find(".");
			string id=line.substr(0,i);
			cout<<id;
			cin>>line;
		}
		return 0;

/*			
		while(line!="#") cin>>line;

		getline(cin,line);
		while(line=="") getline(cin,line);
		
		int i=line.find(".");
	
		string id=line.substr(0,i);
	
		string def=line.substr(i+2);
	
		cout<<nc<<id<<"Def}{"<<def<<"}"<<endl;
	
		while(line.substr(0,5)!="Hours") getline(cin,line);
	
		string hours=line.substr(7);
	
		cout<<nc<<id<<"Hours}{"<<hours<<"}"<<endl;
	
		while(line!="Topics:") getline(cin,line);
	
		getline(cin,line);
		while(line=="") getline(cin,line);
	
		cout<<endl;
	
		while(line!="") {
			int i=line.find(" ");
			string first=line.substr(0,i);
			cout<<nc<<id<<"Topic"<<first<<"}{"<<line<<"}"<<endl;
	
			getline(cin,line);
		}
	
		while(line.find("Aprendizaje:")>line.length()) getline(cin,line);
	
		getline(cin,line);
		while(line=="") getline(cin,line);
	
		cout<<endl;
		while(line!="") {
			int i=line.find(".");
			string number=line.substr(0,i);
			string text=line.substr(i+2);
			cout<<nc<<id<<"Obj"<<number<<"}{"<<text<<"}"<<endl;
			getline(cin,line);
		}
		cout<<endl;
*/	}
		
	
}
