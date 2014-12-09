% Notulen class voor het maken van notulen
%
% Ralph Broenink
% Studievereniging Inter-Actief
% 
% (c) 2009-2010 Ralph Broenink
% Alle rechten voorbehouden.
%
% Versie 0.2.1 (3 mar 2010)
% - Added WOB
% Versie 0.2 (25 feb 2010)
% - Fixed \naar in reactiepuntenlijst
% - Enkele tweaks in de layout
% Versie 0.1 (27 sep 2009)
% - Initiele release

\NeedsTeXFormat{LaTeX2e}[1994/06/01]
\ProvidesClass{notulen}[2010/03/03 Inter-Actief Notulen]

\LoadClass[a4paper,11pt,twoside]{article}

% Packages laden.
%
% Gebruikt voor:
% - babel: Voor Nederlandse afbreking e.d.
% - color: Voor de kleurtjes in de events
% - ifthen: De conditionele statements in dit gehele document
% - fullpage: Zorgt ervoor dat de volledige pagina wordt gebruikt (geen afhankelijkheden)
% - lineno: Accepteert de regelnummers (afhankelijkheid slechts 'modulolinenumbers' hieronder)
% - tocloft: Voor de custom layout van \agenda
% - fancyhdr: De mooie header- en footers
% - marginnote: De tekst in de marge van de events
% - hanging: Verzorgt een nette actiepuntenlijst
% - longtable: Zorgt ervoor dat tabellen over meerdere pagina's heen kunnen
% - fmtcount: Voor doortellen bij de subkopjes
% - substr: Voor het doorgeven van actiepunten in de reactiepuntenlijst
% - hyperref: Vette linkjes in de agenda
\RequirePackage[dutch]{babel}
\RequirePackage[usenames,dvipsnames]{color}
\RequirePackage{ifthen,fullpage,lineno,tocloft,fancyhdr,marginnote,hanging,longtable,fmtcount,substr}
\RequirePackage[colorlinks=false]{hyperref} % als laatste importeren

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Algemeen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Configuratie van PDF
\hypersetup{%
	pdfborder={0 0 0},
	pdfcreator={Inter-Actief Notulen 0.1}
}

% Herziet het \author commando om deze ook in de pdf aan te passen
\renewcommand{\author}[1]{%
	\gdef\@author{#1}%
	\hypersetup{%
		pdfauthor={\@author}
	}
}

% Herziet het \title commando om deze ook in de pdf aan te passen
\renewcommand{\title}[1]{%
	\gdef\@title{#1}%
	\hypersetup{%
		pdftitle={\@title}
	}
}

% Het aantal regels per regelnummer
\modulolinenumbers[5]

% De diepte van de agenda, kan eventueel worden overschreven
\setcounter{tocdepth}{2}

% Besluit en actiepunt e.d. in linker kantlijn
\reversemarginpar
\switchlinenumbers
\pagewiselinenumbers
\runningpagewiselinenumbers

% Opgeven van de vergadercode
% Gebruik: \vcode{vergadercode}
\newcommand{\@vcode} {}
\newcommand{\vcode}[1]{
  \renewcommand{\@vcode}{#1}
}

% Subsections krijgen letters
\def\thesubsection{\abalph{subsection}}
% Subsubsections krijgen romeinse cijfers
\def\thesubsubsection{\roman{subsubsection}}

% Spacing
\setlength{\headheight} {1.5em}
\setlength{\headsep}    {2em}
\setlength{\parindent}  {0pt}
\setlength{\parskip}    {1.2ex plus 0.5ex minus 0.2ex}

% Herziet de sectie-commando's voor betere spacing
\renewcommand{\section}{%
	\vspace{2ex}%
	\@startsection{section}{1}{0mm}{\baselineskip}{0.4ex}{\normalfont\LARGE\bf}%
}
\renewcommand{\subsection}{%
	\vspace{2ex}%
	\@startsection{subsection}{2}{0mm}{0.5ex}{0.2ex}{\normalfont\Large\bf}%
}
\renewcommand{\subsubsection}{%
	\vspace{2ex}%
	\@startsection{subsubsection}{2}{0mm}{0.5ex}{0.2ex}{\normalfont\large\bf}%
}

% Header en footer
\pagestyle{fancy}
\renewcommand{\headrulewidth}{0.5pt}
\renewcommand{\footrulewidth}{0.5pt}

\lhead{\@author\ -- \@title}
\chead{}
\rhead{\@date}
\lfoot{}
\cfoot{\thepage}
\rfoot{}

% Kleuren
\definecolor{ecogreen}{rgb}{0.512,0.592,0.102}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Shorthands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Geeft Inter-/Actief/ weer
% Gebruik: \ia
\newcommand{\ia}{Inter-\textit{Actief}}

% Geeft *eco*mputing weer
% Gebruik: \ecomputing
\newcommand{\ecomputing}{\textbf{\textcolor{ecogreen}{eco}}mputing}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pagina start (aanwezigheidslijst etc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HULPVARIABELE
% Gebruikt door de aanwezigenlijst
\newboolean{algemeen@eerste}%
% Gebruikt door de tijden
\global\expandafter\def\csname algemeen@begin\endcsname{}%
\global\expandafter\def\csname algemeen@eind\endcsname{}%

% Begint een lijst met algemene informatie.
% Gebruik: \begin{algemeen} ... \end{algemeen}
\newenvironment{algemeen}{
	\begin{longtable}{ll}%
	\setboolean{algemeen@eerste}{true}%
	\noindent\ignorespaces%
}{%
	\end{longtable}%
}

% HULPMETHODE
% Geeft een nieuwe regel als dit het eerste element is.
\newcommand{\alg@s}[1]{%
	\ifthenelse{\boolean{algemeen@eerste}}{%
		% Niets
	}{%
		\\
	}%
}

% HULPMETHODE
% Maakt een nieuwe regel in de algemeen-tabel (links, rechts)
\newcommand{\alg@r}[2]{%
	\alg@s\unskip\bf #1 & #2 %\multicolumn{2}{l}{#1} \\
}

% Opgave van de locatie van de vergadering
% Gebruik: \locatie{plaats}
% Alleen binnen de algemeen-environment
\newcommand{\locatie}[1]{%
	\alg@r{Locatie}{#1}
}

% Opgave van de geplande tijden
% Gebruik: \tijden{begintijd}{eindtijd}
% Alleen binnen de algemeen-environment
\newcommand{\tijden}[2]{%
	\alg@r{Tijd}{#1 -- #2}%
	\global\expandafter\def\csname algemeen@begin\endcsname{#1}%
	\global\expandafter\def\csname algemeen@eind\endcsname{#2}%

}

% Opgave van de voorzitter van de vergadering
% Gebruik: \voorzitter
% Alleen binnen de algemeen-environment
\newcommand{\voorzitter}[1]{%
	\alg@r{Voorzitter}{#1}
}

% Opgave van de notulist van de vergadering
% Gebruik: \notulist
% Alleen binnen de algemeen-environment
\newcommand{\notulist}[1]{%
	\alg@r{Notulist}{#1}
}

% Aankondiging van de lijst met aanwezigen
% Gebruik: \aanwezigen
% Alleen binnen de algemeen-environment
\newcommand{\aanwezigen}{%
	\global\expandafter\def\csname algemeen@titel\endcsname{Aanwezig}%
}

% Aankondiging van de lijst met afwezigen
% Gebruik: \afwezigen
% Alleen binnen de algemeen-environment
\newcommand{\afwezigen}{%
	\global\expandafter\def\csname algemeen@titel\endcsname{Afwezig}%
}

% Aankondiging van een aanwezige/afwezige plus de declaratie van \code en \codecode
% Gebruik: \persoon{code}{korte naam}{volledige naam}
%		of \persoon[opm]{code}{korte naam}{volledige naam}
% Alleen binnen de algemeen-environment
\newcommand{\persoon}[4][]{%
	\ifthenelse{\equal{#1}{}} {%
		\alg@s \unskip\bf\algemeen@titel & #4%
	}{%
		\alg@s \unskip\bf\algemeen@titel & #4 {\small (#1)}%
	}
	% Verwijder de tekst die voor het item komt te staan
	\global\expandafter\def\csname algemeen@titel\endcsname{}%
	%
	% Declareer \code en \codecode
	\global\expandafter\def\csname #2\endcsname{#3}%
	\global\expandafter\def\csname #2#2\endcsname{#4}%
	%
	% Maak een actiepunt-account aan met deze naam, zodat deze ook in de juiste volgorde
	% verschijnen in \actiepunten
	\global\expandafter\def\csname ap@naam\theap@namen\endcsname{#3}%
	\global\expandafter\edef\csname ap@naam\theap@namen taken\endcsname{0}%
	\stepcounter{ap@namen}%
}

% Registratie van een afkorting en actiepunt-account, zonder deze weer te geven.
% Gebruik: \persoonh{code}{korte naam}{volledige naam}
\newcommand{\persoonh}[3]{%
	% Declareer \code en \codecode
	\global\expandafter\def\csname #1\endcsname{#2}%
	\global\expandafter\def\csname #1#1\endcsname{#3}%
	%
	% Maak een actiepunt-account aan met deze naam, zodat deze ook in de juiste volgorde
	% verschijnen in \actiepunten
	\global\expandafter\def\csname ap@naam\theap@namen\endcsname{#2}%
	\global\expandafter\edef\csname ap@naam\theap@namen taken\endcsname{0}%
	\stepcounter{ap@namen}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WOB (Wet Openbaarheid Bestuur)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newboolean{wob@on}
\setboolean{wob@on}{true}

% Schakelt de WOB-modus in (standaard)
% Gebruik: \wobon
\newcommand{\wobon}{%
	\setboolean{wob@on}{true}%
}

% Schakelt de WOB-modus uit
% Gebruik: \woboff
\newcommand{\woboff}{%
	\setboolean{wob@on}{false}%
}

\newcommand{\wob}[1]{%
	\ifthenelse{\boolean{wob@on}}{%
		\colorbox{black}{\phantom{\tiny #1}}%
	}{%
		#1%
	}%
}

\newcommand{\wobit}[1]{%
	\ \ \ \ \ %
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Agenda
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Geeft de volledige agenda weer
% Gebruik: \agenda
\newcommand{\agenda}{%
	\setlength{\parskip}{0ex}
	\@starttoc{toc}
	\setlength{\parskip}{1.2ex plus 0.5ex minus 0.2ex}
}
% Stijl voor de agenda
\renewcommand\cftsecfont{}
\renewcommand\addvspace[1]{}
\cftpagenumbersoff{section}
\cftpagenumbersoff{subsection}
\cftpagenumbersoff{subsubsection}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tabel met ruimte voor opmerkingen aan rechterkant
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Gebruik voor in een margelijst
% Gebruik: \begin{margelijst} ... \end{margelijst}
\newboolean{el@eerste}%
\newenvironment{margelijst}{%
	\begin{longtable}[l]{p{3cm}p{12cm}}%
	\setboolean{el@eerste}{true}%
	\noindent\ignorespaces%
}{%
	\unskip%
	\end{longtable}%
}

\newcommand{\mar}[1][]{%
	\unskip%
	\ifthenelse{\boolean{el@eerste}}{%
		% Niets
	}{%
		\\[\parskip]%
	}%
	\setboolean{el@eerste}{false}%
	#1 & \noindent\ignorespaces%
}%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gebeurtenis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Een evenement in de vergadering, bijvoorbeeld een actiepunt of besluit
% Gebruik: \begin{event}{type}{kleur} ... \end{event}
%		of \begin{event}[kantlijnkleur]{type}{kleur} ... \end{event}
\newenvironment{event}[4][black]{%
	\par\vspace{0.2cm}%
	~\unskip\marginnote{\color{#1}\bf\footnotesize #2}[#4]%
	\color{#3}\em\ignorespaces%
}{%
	\par\ignorespaces%
}

% Een gebeurtenis
% Gebruik: \gebeurtenis{event}
%		of \gebeurtenis[tijd]{event}
\newcommand{\gebeurtenis}[2][]{%
	\begin{event}[Purple]{#1}{Purple}{0ex}%
		#2%
	\end{event}%
}

% Een opening
% Gebruik: \opening[tijd]
\newcommand{\opening}[1][]{%
	\ifthenelse{\equal{#1}{}}{%
		\gebeurtenis[\algemeen@begin]{De voorzitter opent de vergadering.}%
	}{%
		\gebeurtenis[#1]{De voorzitter opent de vergadering.}%
	}%
}

% Een sluiting
% Gebruik: \sluiting[tijd]
\newcommand{\sluiting}[1][]{%
	\ifthenelse{\equal{#1}{}}{%
		\gebeurtenis[\algemeen@eind]{De voorzitter sluit de vergadering.}%
	}{%
		\gebeurtenis[#1]{De voorzitter opent de vergadering.}%
	}%
}

% Een schorsing (voor luie mensen)
% Gebruik: \schorsing{begintijd}{eindtijd}
\newcommand{\schorsing}[2]{%
	\gebeurtenis[#1]{De voorzitter schorst de vergadering.}
	\gebeurtenis[#2]{De voorzitter hervat de vergadering.}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stemmingen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Begint een stemming, waarbij blanco stemmen bij de meeste op wordt geteld en 
% er geen onthouding wordt genotuleerd
% Gebruik: \stemmingO{voorstel}{voor}{tegen}{blanco}
%		of \stemmingO[conclusie]{voorstel}{voor}{tegen}{blanco}
\newcommand{\stemmingO}[5][]{%
	\stemming[#1]{#2}{#3}{#4}{#5}{geen}
}

% Begint een stemming, waarbij blanco stemmen bij de meeste op wordt geteld.
% Gebruik: \stemming{voorstel}{voor}{tegen}{blanco}{onthouding}
%		of \stemming[conclusie]{voorstel}{voor}{tegen}{blanco}{onthouding}
\newcommand{\stemming}[6][]{%
	\stemmingC[#1]{Stemming}{#2}{#3}{#4}{#5}{#6}
}

% Begint een stemming, waarbij blanco stemmen bij de meeste op wordt geteld.
% Biedt de mogelijkheid om een ander type op te geven.
% Gebruik: \stemmingC{type}{voorstel}{voor}{tegen}{blanco}{onthouding}
%		of \stemmingC[conclusie]{type}{voorstel}{voor}{tegen}{blanco}{onthouding}
\newcounter{stem@temp}%
\newcommand{\stemmingC}[7][]{%
	\begin{event}{#2}{Orange}{0ex}%
		{\bf \em #3}%
		\ifthenelse{\equal{#4}{geen} \and \equal{#5}{geen} \and \equal{#6}{geen} \and \equal{#7}{geen}}{%
			\par%
		}{%
			\begin{longtable}{ll}%
				\ifthenelse{\not \equal{#4}{geen}}{%
					\bf\em Voor & \em #4%
				}{}%
				\ifthenelse{\not \equal{#5}{geen}}{%
					\ifthenelse{\equal{#4}{geen}}{}{\\}%
					\bf\em Tegen & \em #5%
				}{}%
				\ifthenelse{\not \equal{#6}{geen}}{%
					\ifthenelse{\equal{#4}{geen} \and \equal{#5}{geen}}{}{\\}%
					\bf\em Blanco & \em #6%
				}{}%
				\ifthenelse{\not \equal{#7}{geen}}{%
					\ifthenelse{\equal{#4}{geen} \and \equal{#5}{geen} \and \equal{#6}{geen}}{}{\\}%
					\bf\em Onthouding & \em #7%
				}{}%
			\end{longtable}%
		}%
		\ifthenelse{\equal{#1}{}}{%
			\ifthenelse{\equal{#4}{#5}}{%
				De stemming is onbeslist.%
			}{%
				\ifthenelse{#4 > #5}{%
					\setcounter{stem@temp}{#4}%
					\addtocounter{stem@temp}{#6}%
					Het voorstel wordt aangenomen met \arabic{stem@temp} tegen #5.%
				}{%
					\setcounter{stem@temp}{#5}%
					\addtocounter{stem@temp}{#6}%
					Het voorstel wordt verworpen met #4 tegen \arabic{stem@temp}.%
				}%
			}%
		}{%
			#1%
		}%
	\end{event}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Besluitenlijstjes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Het totaal aantal besluiten
\newcounter{bs@totaal}
\setcounter{bs@totaal}{0}

\newcommand{\bs@nrcalc}{%
	\ifthenelse{\equal{\@vcode}{}}{%
		\global\expandafter\def\csname bs@nrstring\endcsname{\arabic{bs@totaal}}%
	}{%
		\ifthenelse{\value{bs@totaal} < 10}{%
			\global\expandafter\def\csname bs@nrstring\endcsname{\@vcode .0\arabic{bs@totaal}}%
		}{%
			\global\expandafter\def\csname bs@nrstring\endcsname{\@vcode .\arabic{bs@totaal}}%
		}%
	}%
}

% Definieert een nieuw besluit
% Gebruik: \besluit{tekst}
\newcommand{\besluit}[1]{%
	% Actiepunttotaal ophogen
	\stepcounter{bs@totaal}%
	\bs@nrcalc%
	\begin{event}{Besluit}{blue}{0ex}%
		\label{bs:\arabic{bs@totaal}}%
		#1%
	\end{event}%
	\addtocontents{lob}{\protect\@besluit{\bs@nrstring}{#1}{bs:\arabic{bs@totaal}}}%
}

% HULPVARIABELEN
% Gebruikt door \besluiten
\newcounter{bs@besluiten}
\newcounter{bs@curbesluit}

% Geeft een opsomming van alle besluiten in de vergadering
% Gebruik: \besluiten
\newcommand\besluiten{%
	% Elk besluit gaat in volgorde van opgave hier doorheen
	\setcounter{bs@besluiten}{0}%
	\global\def\@besluit##1##2##3{ % nummer, naam, ref
		\global\expandafter\def\csname bs@besluit\thebs@besluiten \endcsname{%
			\item {\bf ##1} ##2 {\tiny \mbox{(\hyperref[##3]{pagina~\pageref*{##3}})}}%
		}%
		% Het totaal aantal besluiten++
		\stepcounter{bs@besluiten}%
	}%
	%
	% Laad de loa-file en haal die door \@besluit:
	\@starttoc{lob}%
	\setcounter{bs@curbesluit}{0}%
	%
	\ifthenelse{\thebs@besluiten > 0}{%
		\begin{itemize}%
			% Loop alle gevonden besluiten af:
			\whiledo{\thebs@curbesluit < \thebs@besluiten}{%
				\csname bs@besluit\thebs@curbesluit \endcsname%
				\stepcounter{bs@curbesluit}%
			}%
		\end{itemize}%
	}{%
		\emph{Er zijn geen besluiten geformuleerd}%
	}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Actiepuntenlijstjes
% 
% Met dank aan het cls-bestand van A-Eskwadraat (commando '\actiepunten')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% HULPVARIABELE
% Gebruikt door de reactiepuntenlijst
\newboolean{reap@eerste}%

% Een herhaling van de lopende actiepunten (de reactiepuntenlijst)
% Gebruik: \begin{reactiepuntenlijst} ... \end{reactiepuntenlijst}
\newenvironment{reactiepuntenlijst}{
	\begin{longtable}{l|p{11cm}|l}%
	\bf Nummer & \bf Actiepunt & \bf Status\\%
	\hline\endhead%
	\setboolean{reap@eerste}{true}%
	\noindent\ignorespaces%
}{%
	\end{longtable}%
}

% Een bestaand actiepunt
% Gebruik: \reactiepunt{nummer}{persoon}{actiepunt}{status}
%		of \reactiepunt[deadline]{nummer}{persoon}{actiepunt}{status}
\newcommand{\reactiepunt}[5][]{%
	\ifthenelse{\equal{#5}{V}}{%
		\reap@item{#2}{#3}{#4}{voldaan}{#1}%
	}{%
		\ifthenelse{\equal{#5}{X}}{%
			\reap@item{#2}{#3}{#4}{vervallen}{#1}%
		}{%
			\vphantom{\smash{#5}}% #5 moet worden uitgevoerd alvorens de naar-settings zijn correct
			\ifthenelse{\equal{\reap@naarset}{1}}{%
				\reap@item{#2}{#3}{#4}{naar \reap@naar}{#1}%
				\addtocontents{loa}{\protect\@actiepunt{#2}{\reap@naar}{#4}{}{#1}}%
				\global\expandafter\def\csname reap@naarset\endcsname{0}%
			}{%
				\ifthenelse{\equal{#5}{L}}{%
					\reap@item{#2}{#3}{#4}{lopend}{#1}%
				}{%
					% Weergave op de plek waar het gedefinieerd is:
					\reap@item{#2}{#3}{#4}{#5}{#1}%
				}%
				% Toevoegen aan de lijst van actiepunten:
				\addtocontents{loa}{\protect\@actiepunt{#2}{#3}{#4}{}{#1}}%
			}%					
			% Actiepunttotaal ophogen
			\stepcounter{ap@totaal}%
		}%
	}%
}

\global\expandafter\def\csname reap@naar\endcsname{}%
\global\expandafter\def\csname reap@naarset\endcsname{0}%

% Verzorgt de mogelijkheid om actiepunten door te geven aan een ander
% Gebruik: \naar{naam}
\newcommand{\naar}[1]{%
	\global\expandafter\def\csname reap@naar\endcsname{#1}%
	\global\expandafter\def\csname reap@naarset\endcsname{1}%
}

% HULPMETHODE
% Verzorgt de layout in de tabel
% nummer, naam, actiepunt, status, deadline (opt)
\newcommand{\reap@item}[5]{%
	\ifthenelse{\boolean{reap@eerste}}{%
		% Niets
	}{%
		\\%
	}%
	#1 & \hangpara{1cm}{1}\textbf{#2} #3 & #4
}

% Houdt het huidige actiepuntnummer bij.
\newcounter{ap@nummer}
\setcounter{ap@nummer}{0}
\newcounter{ap@totaal}
\setcounter{ap@totaal}{0}

% HULPMETHODE
% Berekent het actiepuntnummer
\newcommand{\ap@nrcalc}{%
	\ifthenelse{\equal{\@vcode}{}}{%
		\global\expandafter\def\csname ap@nrstring\endcsname{\arabic{ap@nummer}}%
	}{%
		\ifthenelse{\value{ap@nummer} < 10}{%
			\global\expandafter\def\csname ap@nrstring\endcsname{\@vcode .0\arabic{ap@nummer}}%
		}{%
			\global\expandafter\def\csname ap@nrstring\endcsname{\@vcode .\arabic{ap@nummer}}%
		}%
	}%
}

% Houdt het laatste actiepunt bij (geinitialiseerd op:)
\global\expandafter\def\csname ap@laatsteap\endcsname{krijgt geen actiepunt toegewezen%
		\ClassError{notulen}{Gebruik van \herhaal \space voordat een actiepunt is gedefinieerd}{Declareer eerst een actiepunt}}
\global\expandafter\def\csname ap@laatstedl\endcsname{}
\ap@nrcalc
\global\expandafter\def\csname ap@laatstenr\endcsname{\ap@nrstring}

% Het overzicht van alle actiepunten
% Gebruik: \begin{actiepuntenlijst} ... \end{actiepuntenlijst}
\newenvironment{actiepuntenlijst}{%
	\begin{longtable}{l|p{11cm}|l}%
	\bf Nummer & \bf Actiepunt & \bf Deadline\\%
	\hline\endhead%
}{%
	\end{longtable}%
}

% Shortcut voor \actiepunt
% Gebruik: zie \actiepunt
\newcommand{\ap}[3][]{%
	\actiepunt[#1]{#2}{#3}%
}

% Een normaal nieuw hip actiepunt
% Gebruik: \actiepunt{persoon}{actiepunt}
%		of \actiepunt[deadline]{persoon}{actiepunt}
\newcommand{\actiepunt}[3][]{%
	% Actiepuntnummer ophogen
	\stepcounter{ap@nummer}%
	\ap@nrcalc%
	% Actiepunttotaal ophogen
	\stepcounter{ap@totaal}%
	% Weergave op de plek waar het gedefinieerd is:
	\begin{event}{Actiepunt}{red}{0ex}%
		\label{ap:\arabic{ap@totaal}}%
		\textbf{#2} #3%
		\ifthenelse{\equal{#1}{}}{}{ (deadline #1)}%
	\end{event}%
	% Toevoegen aan de lijst van actiepunten:
	\addtocontents{loa}{\protect\@actiepunt{\ap@nrstring}{#2}{#3}{ap:\arabic{ap@totaal}}{#1}}%
	% Huidige actiepunt opslaan voor \herhaal
	\global\expandafter\def\csname ap@laatsteap\endcsname{#3}%
	\global\expandafter\def\csname ap@laatstedl\endcsname{#1}%
	\global\expandafter\def\csname ap@laatstenr\endcsname{\ap@nrstring}%
	
}

% Een eerder gegeven actiepunt herhalen voor een ander persoon
% Gebruik: \herhaal{persoon}
%		of \herhaal[deadline]{persoon}
\newcommand{\herhaal}[2][onveranderd]{%
	% Actiepunttotaal ophogen
	\stepcounter{ap@totaal}%
	% Weergave op de plek waar het gedefinieerd is:
	\begin{event}{Actiepunt}{red}{0ex}%
		\label{ap:\arabic{ap@totaal}}%
		\textbf{#2} \csname ap@laatsteap\endcsname%
		% Deadline weergeven alleen als het niet leeg is. Als onveranderd, de oude deadline weergeven (mits niet leeg)
		\ifthenelse{\equal{#1}{onveranderd}}{%
			\ifthenelse{\equal{\csname ap@laatstedl\endcsname}{}}{}{ (deadline \csname ap@laatstedl\endcsname)}%
		}{%
			\ifthenelse{\equal{#1}{}}{}{ (deadline #1)}%
		}%
	\end{event}%
	% Toevoegen aan de lijst van actiepunten:
	% Eerste is voor de oude deadline, de tweede voor een herdefinitie
	\ifthenelse{\equal{#1}{onveranderd}}{%
		\addtocontents{loa}{\protect\@actiepunt{\csname ap@laatstenr\endcsname}{#2}{\csname ap@laatsteap\endcsname}{ap:\arabic{ap@totaal}}{\csname ap@laatstedl\endcsname}}%
	}{%
		\addtocontents{loa}{\protect\@actiepunt{\csname ap@laatstenr\endcsname}{#2}{\csname ap@laatsteap\endcsname}{ap:\arabic{ap@totaal}}{#1}}%
	}
}

% HULPMETHODE
% Geeft het huidige actiepuntnummer
\newcommand{\apnr}{%
	\ap@nrstring
}

% HULPMETHODE
% Verzorgt de layout in de tabel
% nummer, naam, actiepunt, ref, deadline (opt)
\newcommand{\ap@item}[5]{%
	\noindent #1 & \hangpara{1cm}{1}\textbf{#2} #3 %
	\ifthenelse{\equal{#4}{}}{%
		% Niets
	}{%
		{\tiny \mbox{(\hyperref[#4]{pagina~\pageref*{#4}})}}%
	}%
	& #5%
	% Eigenlijk wil je \reactiepunt[#5]{#1}{#2}{#3}{}
	\wlog{\string\reactiepunt[#5]{#1}{#2}{#3}{}}%
}

% HULPVARIABELEN
% Hulpvariabelen voor \actiepunten
\newcounter{ap@namen}
\setcounter{ap@namen}{0}
\newcounter{ap@curnaam}
\newcounter{ap@tmp}
\newboolean{ap@gevonden}

% Actiepuntenlijst gegroepeerd per persoon
% Gebruik: \actiepunten
\newcommand\actiepunten{%
	% Elk actiepunt gaat in volgorde van opgave hier doorheen
	\global\def\@actiepunt##1##2##3##4##5{ % nummer, naam, actiepunt, ref, deadline (opt)
		\setcounter{ap@curnaam}{0}%
		\setboolean{ap@gevonden}{false}%
		%
		% Zoek ##2 op in alle al bekende namen
		\whiledo{\theap@curnaam < \theap@namen \and \not \boolean{ap@gevonden}}{%
			\ifthenelse{\equal{##2}{\csname ap@naam\theap@curnaam\endcsname}}{%
				% Gevonden
				% Laad het aantal eerdere taken van deze persoon in een counter:
				\setcounter{ap@tmp}{\csname ap@naam\theap@curnaam taken\endcsname}%
				%
				% Definieer \ap@naamXXtaakXX als de nieuwe taak:
				\global\expandafter\def\csname ap@naam\theap@curnaam taak\theap@tmp\endcsname{%
					\ap@item{##1}{##2}{##3}{##4}{##5}%
				}%
				%
				% Hoog het aantal eerdere taken op:
				\stepcounter{ap@tmp}%
				\global\expandafter\edef\csname ap@naam\theap@curnaam taken\endcsname{\theap@tmp}%
				%
				% Onthoud dat deze naam al bestond:
				\setboolean{ap@gevonden}{true}%
			}{%
				% Niet gevonden; doorzoeken
			}%
			\stepcounter{ap@curnaam}%
		}%
		%
		% Als de naam niet gevonden is, moeten we hem als nieuwe naam definieren:
		\ifthenelse{\boolean{ap@gevonden}}{%
			% Was gevonden
		}{%
			% Initialiseer naam, aantal taken (1) en de eerste taak:
			\global\expandafter\def\csname ap@naam\theap@namen\endcsname{##2}%
			\global\expandafter\edef\csname ap@naam\theap@namen taken\endcsname{1}%
			\global\expandafter\def\csname ap@naam\theap@namen taak0\endcsname{%
				\ap@item{##1}{##2}{##3}{##4}{##5}%
			}%
			%
			% Het totaal aantal namen++
			\stepcounter{ap@namen}%
		}%
	}%
	%
	% Laad de loa-file en haal die door \@actiepunt:
	\@starttoc{loa}%
	\setcounter{ap@curnaam}{0}%
	\newboolean{ap@eerste}%
	\setboolean{ap@eerste}{true}%
	%
	%
	\ifthenelse{\theap@totaal > 0}{%
		\begin{actiepuntenlijst}%
		% Loop alle gevonden namen af:
		\whiledo{\theap@curnaam < \theap@namen}{%
			% Print naam:
			%\apnaamgroep{\csname ap@naam\theap@curnaam\endcsname}%
			\setcounter{ap@tmp}{0}%
			% Loop alle taken van deze persoon af:
			\whiledo{\theap@tmp < \csname ap@naam\theap@curnaam taken\endcsname}{%
				\ifthenelse{\boolean{ap@eerste}}{%
					% Niets
				}{%
					\\%
				}%
				% Print opgeslagen taak:
				\csname ap@naam\theap@curnaam taak\theap@tmp\endcsname%
				\stepcounter{ap@tmp}%
				\setboolean{ap@eerste}{false}%
			}%
			\stepcounter{ap@curnaam}%
		}%
		\end{actiepuntenlijst}%
	}{%
		\emph{Er zijn geen lopende actiepunten.}%
	}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\renewcommand\maketitle{\par
  \begingroup
    \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{\parindent 1em\noindent
            \hb@xt@1.8em{%
                \hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
    \global\@topnum\z@   % Prevents figures from going at top of page.
		\begin{center}%
			{\large \@author \par}%
			\vskip 0.5em%
			{\LARGE\bf \@title \par}%
			\vskip 1em%
			{\large \@date \par}%       % Set date in \large size.
			\vskip 2em%
		\end{center}\par
    \thispagestyle{plain}\@thanks
  \endgroup
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@maketitle\relax
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
}


\endinput