/* Generated Code (IMPORT) */
/* Source File: SLR Project.xlsx */
/* Source Path: /home/u60843638/5318-Applied Linear Regression */
/* Code generated on: 3/21/22, 11:50 AM */

%web_drop_table(WORK.IMPORT);


FILENAME REFFILE '/home/u60843638/5318-Applied Linear Regression/SLR Project.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;


%web_open_table(WORK.IMPORT);

data WORK.IMPORT;
  infile data;
  input Runs_scored Balls_faced;
proc print;

proc means data=WORK.IMPORT;			/* means, SDs, min, max for each variable */
  var Runs_scored Balls_faced;	/* for variables */

proc corr data=WORK.IMPORT;
  var Runs_scored Balls_faced;

axis1 label=(angle = 90);
proc gplot;
  /* plot minutes vertical and num_mach horizontal */
  plot Runs_scored*Balls_faced / vaxis=axis1;
  
proc corr data=Runs_scored;
	var Runs_scored Balls_faced;
	



proc means data=WORK.IMPORT;			/* means, SDs, min, max for each variable */
  var Runs_scored Num_innings;	/* for variables */

proc corr data=WORK.IMPORT;
  var Runs_scored Num_innings;

axis1 label=(angle = 90);
proc gplot;
  /* plot minutes vertical and num_mach horizontal */
  plot Runs_scored*Num_innings / vaxis=axis1;
  
proc corr data=WORK.IMPORT;
	var Runs_scored Num_innings;
	
	
	
	
proc means data=WORK.IMPORT;			/* means, SDs, min, max for each variable */
  var Runs_scored Average;	/* for variables */

proc corr data=WORK.IMPORT;
  var Runs_scored Average;

axis1 label=(angle = 90);
proc gplot;
  /* plot minutes vertical and num_mach horizontal */
  plot Runs_scored*Average / vaxis=axis1;
  
proc corr data=WORK.IMPORT;
	var Runs_scored Average;
	
	


proc means data=WORK.IMPORT;			/* means, SDs, min, max for each variable */
  var Runs_scored Strike_rate;	/* for variables */

proc corr data=WORK.IMPORT;
  var Runs_scored Strike_rate;

axis1 label=(angle = 90);
proc gplot;
  /* plot minutes vertical and num_mach horizontal */
  plot Runs_scored*Strike_rate / vaxis=axis1;
  
proc corr data=WORK.IMPORT;
	var Runs_scored Strike_rate;
	




	
/* Simple Linear Regression */
/* Output shown below */
proc reg;
model Runs_scored = Balls_faced ;
output out=calcout predicted=yhat residual=e;
proc print data=calcout;
/* Scatter plot with fitted line */
goptions reset = all;
symbol1 v=dot c=black;
symbol2 v=none i=join c=black;
axis1 label=(angle = 90);
proc gplot data = calcout;
plot Runs_scored*Balls_faced yhat*Balls_faced/ overlay vaxis=axis1;
run;

	
	