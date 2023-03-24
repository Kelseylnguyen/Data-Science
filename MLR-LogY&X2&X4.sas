/* Generated Code (IMPORT) */
/* Source File: SLR Project - V_T6.xlsx */
/* Source Path: /home/u60823028/sasuser.v94/SLR */
/* Code generated on: 4/21/22, 4:37 PM */

%web_drop_table(WORK.IMPORT4);


FILENAME REFFILE '/home/u60823028/sasuser.v94/SLR/SLR Project - V_T6.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT4;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;


%web_open_table(WORK.IMPORT);

proc sgscatter data=work.import;
matrix L_Runs_scored Num_innings L_Balls_faced Average L_Strike_rate;

proc corr data=work.import noprob;
	var L_Runs_scored Num_innings L_Balls_faced Average L_Strike_rate;

proc reg data=work.import;
	model L_Runs_scored=Num_innings L_Balls_faced Average L_Strike_rate / influence ss1 
		vif i;
	output out=patout predicted=yhat residual=e student=tres h=hii cookd=cookdi 
		dffits=dffitsi;

	/* IML */
proc iml;
	use work.import;
	read all var{L_Runs_scored} into y;
	read all var{Num_innings L_Balls_faced Average L_Strike_rate} into X;
	n=nrow(X);
	X=J(n, 1) || X;

	/* add column of 1s */
	print X;
	p=ncol(X);
	xpx=X`*X;
	print xpx;
	xpxi=inv(xpx);
	print xpxi;
	xpy=X`*y;
	print xpy;
	b=xpxi*xpy;

	/* LSEs */
	print b;
	store;

	/* store everything */
	quit;

proc rank normal=blom out=enrm data=patout;
	var e;
	ranks enrm;

data patnew;
	set patout;
	set enrm;
	label enrm=’Normal Scores’;
	id=_n_;
	label id=’Observation Number’;

PROC CORR data=patnew;
	var e enrm;
	goptions reset=all;
	symbol1 v=dot c=black;
	axis1 label=(angle=90);

proc gplot data=patnew;
	plot e*yhat /vref=0 vaxis=axis1;
	symbol1 v=dot c=black;
	axis1 label=(angle=90);

proc gplot data=patnew;
	plot e*enrm / vaxis=axis1;
	run;
	goptions reset=all;
	symbol1 v=dot i=join c=black;
	axis1 label=(angle=90);

proc gplot data=patnew;
	plot e*id / vaxis=axis1;
	run;

proc capability data=patnew;
	var e;
	histogram e;

data calcmod;
	set patout;
	group=1;

	if L_Runs_scored > 2.85 then
		group=2;

proc sort data=calcmod;
	by group;

proc univariate data=calcmod noprint;
	by group;
	var e;
	output out=mout median=mede;

proc print data=mout;
	var group mede;

data mtemp;
	merge calcmod mout;
	by group;
	d=abs(e - mede);

proc sort data=mtemp;
	by group;

proc ttest data=mtemp;
	class group;
	var d;

data cutoffs;
	tinvtres=tinv(.9995, 44);
	finv50=finv(0.50, 5, 45);
	output;

goptions reset = all;
symbol1 v=dot c=black;
axis1 label=(angle = 90);
proc gplot data = patout;
  plot e*yhat /vref = 0 vaxis = axis1;
  plot e*enrm / vaxis = axis1;
  plot e*Num_innings /vref = 0 vaxis = axis1;
  plot e*L_Balls_faced /vref = 0 vaxis = axis1;
  plot e*Average /vref = 0 vaxis = axis1;
  plot e*L_Strike_rate /vref = 0 vaxis = axis1;
run;

data work.import; set patout;
  x1x2 = Num_innings*L_Balls_faced;
  x1x3 = Num_innings*Average;
  x1x4 = Num_innings*L_Strike_rate;
  x2x3 = L_Balls_faced*Average;
  x2x4 = L_Balls_faced*L_Strike_rate;
  x3x4 = Average*L_Strike_rate;
  stdx1x2 = stdx1*stdx2;
  stdx1x3 = stdx1*stdx3;
  stdx1x4 = stdx1*stdx4;
  stdx2x3 = stdx2*stdx3;
  stdx2x4 = stdx2*stdx4;
  stdx3x4 = stdx3*stdx4;
  
proc reg  data=work.import;
  model x1x2 = Num_innings L_Balls_faced Average L_Strike_rate;
  output out=outint residual=ex1x2;

proc reg  data=outint;
  model x1x3 = Num_innings L_Balls_faced Average L_Strike_rate;
  output out=outint residual=ex1x3;

proc reg  data=outint;
  model x1x4 = Num_innings L_Balls_faced Average L_Strike_rate;
  output out=outint residual=ex1x4;

proc reg  data=outint;
  model x2x3 = Num_innings L_Balls_faced Average L_Strike_rate;
  output out=outint residual=ex2x3;

proc reg  data=outint;
  model x2x4 = Num_innings L_Balls_faced Average L_Strike_rate;
  output out=outint residual=ex2x4;

proc reg  data=outint;
  model x3x4 = Num_innings L_Balls_faced Average L_Strike_rate;
  output out=outint residual=ex3x4;

data work.import; set patout; set outint;
  label ex1x2 = 'e(x1x2 | x1,x2,x3,x4)';
  label ex1x3 = 'e(x1x3 | x1,x2,x3,x4)';
  label ex1x4 = 'e(x1x4 | x1,x2,x3,x4)';
  label ex2x3 = 'e(x2x3 | x1,x2,x3,x4)';
  label ex2x4 = 'e(x2x4 | x1,x2,x3,x4)';
  label ex3x4 = 'e(x3x4 | x1,x2,x3,x4)';
  label e = 'e(Y | x1,x2,x3,x4)';
proc print;

proc gplot data = work.import;
  plot e*ex1x2 /vref = 0 vaxis = axis1;
  plot e*ex1x3 /vref = 0 vaxis = axis1;
  plot e*ex1x4 /vref = 0 vaxis = axis1;
  plot e*ex2x3 /vref = 0 vaxis = axis1;
  plot e*ex2x4 /vref = 0 vaxis = axis1;
  plot e*ex3x4 /vref = 0 vaxis = axis1;
run;


proc corr data=work.import noprob;
  var L_Runs_scored Num_innings L_Balls_faced Average L_Strike_rate x1x2 x1x3 x1x4 x2x3 x2x4 x3x4;
  
/* Standardize predictor variables */
/* Make copy of variables that will be standardized */

data work.import; set surg2std;
  stdx1 = Num_innings;
  stdx2 = L_Balls_faced;
  stdx3 = Average;
  stdx4 = L_Strike_rate;
  
proc standard data=surg2std mean=0 std=1 out=surg2std;
  var stdx1 stdx2 stdx3 stdx4;
proc print;

data surg2std; set surg2std;  
  stdx1x2 = stdx1*stdx2;
  stdx1x3 = stdx1*stdx3;
  stdx1x4 = stdx1*stdx4;
  stdx2x3 = stdx2*stdx3;
  stdx2x4 = stdx2*stdx4;
  stdx3x4 = stdx3*stdx4;
 

  
proc gplot data = work.import;
  plot e*stdx1x2 /vref = 0 vaxis = axis1;
  plot e*stdx1x3 /vref = 0 vaxis = axis1;
  plot e*stdx1x4 /vref = 0 vaxis = axis1;
  plot e*stdx2x3 /vref = 0 vaxis = axis1;
  plot e*stdx2x4 /vref = 0 vaxis = axis1;
  plot e*stdx3x4 /vref = 0 vaxis = axis1;
run;

data work.import; set surg2std; set outint;
  label stdx1x2 = 'e(stdx1x2 | x1,x2,x3,x4)';
  label stdx1x3 = 'e(stdx1x3 | x1,x2,x3,x4)';
  label stdx1x4 = 'e(stdx1x4 | x1,x2,x3,x4)';
  label stdx2x3 = 'e(stdx2x3 | x1,x2,x3,x4)';
  label stdx2x4 = 'e(stdx2x4 | x1,x2,x3,x4)';
  label stdx3x4 = 'e(stdx3x4 | x1,x2,x3,x4)';
  label e = 'e(Y | x1,x2,x3,x4)';
proc print;

proc corr data=surg2std noprob;
  var L_Runs_scored Num_innings L_Balls_faced Average L_Strike_rate stdx1x2 stdx1x3 stdx1x4 stdx2x3 stdx2x4 stdx3x4;
  
  
proc reg data=surg2std;
model L_Runs_scored = Num_innings L_Balls_faced Average L_Strike_rate stdx1x2 stdx1x3 stdx1x4 stdx2x3 stdx2x4 stdx3x4 / selection = adjrsq cp aic sbc start=1 stop=1 best=2;

proc reg data=surg2std;
model L_Runs_scored = Num_innings L_Balls_faced Average L_Strike_rate stdx1x2 stdx1x3 stdx1x4 stdx2x3 stdx2x4 stdx3x4 / selection = adjrsq cp aic sbc start=2 stop=2 best=2;

proc reg data=surg2std;
model L_Runs_scored = Num_innings L_Balls_faced Average L_Strike_rate stdx1x2 stdx1x3 stdx1x4 stdx2x3 stdx2x4 stdx3x4 / selection = adjrsq cp aic sbc start=3 stop=3 best=2;

proc reg data=surg2std;
model L_Runs_scored = Num_innings L_Balls_faced Average L_Strike_rate stdx1x2 stdx1x3 stdx1x4 stdx2x3 stdx2x4 stdx3x4 / selection = adjrsq cp aic sbc start=4 stop=4 best=2;

proc reg data=surg2std;
model L_Runs_scored = Num_innings L_Balls_faced Average L_Strike_rate stdx1x2 stdx1x3 stdx1x4 stdx2x3 stdx2x4 stdx3x4 / selection = adjrsq cp aic sbc start=5 stop=5 best=2;

proc reg data=surg2std;
model L_Runs_scored = Num_innings L_Balls_faced Average L_Strike_rate stdx1x2 stdx1x3 stdx1x4 stdx2x3 stdx2x4 stdx3x4 / selection = adjrsq cp aic sbc start=6 stop=6 best=2;

proc reg data=surg2std;
model L_Runs_scored = Num_innings L_Balls_faced Average L_Strike_rate stdx1x2 stdx1x3 stdx1x4 stdx2x3 stdx2x4 stdx3x4 / selection = adjrsq cp aic sbc start=1 stop=10 best=14;


proc reg data=surg2std;
 model L_Runs_scored = Num_innings L_Balls_faced Average L_Strike_rate stdx1x2 stdx1x3 stdx1x4 stdx2x3 stdx2x4 stdx3x4 / selection = backward slstay=.05;

proc reg data=surg2std;
 model L_Runs_scored = Num_innings L_Balls_faced Average L_Strike_rate stdx1x2 stdx1x3 stdx1x4 stdx2x3 stdx2x4 stdx3x4 / selection = stepwise slentry=.05 slstay=.05;

proc reg data=surg2std;
	model L_Runs_scored= L_Balls_faced L_Strike_rate / influence ss1 
		vif i;
	output out=patout predicted=yhat residual=e student=tres h=hii cookd=cookdi 
		dffits=dffitsi;

proc reg data=surg2std;
	model L_Runs_scored= L_Balls_faced/ influence ss1 
		vif i;
	output out=patout predicted=yhat residual=e student=tres h=hii cookd=cookdi 
		dffits=dffitsi;



  
   
