#==========================================
#------------SDL header part---------------
#==========================================

# Before you run this script you should run the ain theshold procedure programmed in the thermode: 3x ramp-increase from 20* until it gets painfull
# The average threshold is then used for this calibration procedure which applies 2x11 different temperatures for 2,5 sec and rates the painlevel with VAS scales.  
# Output is then run trhough an R script to determine VAS 40 and VAS80. For relief 20* will be used. 

# changes by marvdsch (jan 2018)
# Removed redundancies in the scrip like defenition of nothing stimuli
# 


#-------
# TO DO
#-------

scenario = "pain_adjust_capsaicin";
pcl_file = "pain_adjust_capsaicin.pcl";  		

#scenario_type = fMRI_emulation;
#scenario_type = fMRI;
#pulse_code = 222;					# stimmt der Pulse-Code so?
#pulses_per_scan = 1;
#scan_period = 2600;				#only during "scenario_type = fMRI_emulation" - auskommentieren, wenn tatsrt
no_logfile = false;

response_matching = simple_matching;
active_buttons    = 6;
button_codes      = 1000, 2000, 3000, 4000, 5000, 6000; 
# 1 = space, 2 = <-- , 3 = --> 4 = enter, 5 = <-- (up), 6 = --> (up)
# 1 = Leertaste, # 2 = linke Maustaste, # 3 = rechte Maustaste, # 4 = mittlere Maustaste, # 5 = linke Maustaste hoch, # 6 = rechte Maustaste hoch

default_font_size = 40;
default_text_color = 255,255,255;
default_background_color  = 0, 0 ,0;


###diese 3 Zeilen auskommentieren, wenn ohne ports!
response_port_output = false;   
write_codes          = true;   
pulse_width          = 200;


stimulus_properties = name, string, resp_type, number, resp_time, number;
event_code_delimiter = ":";

begin;

/*
$rt_begin 						=    0;     
$rt_end   						= 2000;  

$dur_trial          			= 30000;  
$dur_iti          			= 2000; #jitter??

$dur_anticipation_pain	  	= 1000;
$dur_pain						= 1500;

$dur_pause_trial				= 3000;  # evtl hier runter gehen mit der zeit
*/


#$dur_trial          			= 4500;  
$dur_pause_vas_trial			= 2000;
$dur_iti          			= 1000;  


$dur_anticipation_pain	  	= 1000;

$dur_pain						= 2500; #2500 +500 for pause;
$time_pain_event				= 1001;  # evtl hier runter gehen mit der zeit

$dur_pause_event				= 500;  # evtl hier runter gehen mit der zeit
$time_pause_event				= 3502;  # evtl hier runter gehen mit der zeit



#==========================================
#-----------------SDL part-----------------
#==========================================


#==========================================
#--------------Stimulus Part---------------
#==========================================

#--------------
# Figures
#--------------

# Geometrische Figuren
picture{bitmap { filename = "stimuli\\Quadrat.jpg"; };x=0; y=100; }Bild_1;
picture{bitmap { filename = "stimuli\\Rechteck.jpg"; }; x=0;y=100;}Bild_2;
picture{bitmap { filename = "stimuli\\Raute.jpg"; }; x=0;y=100;}Bild_3;
picture{bitmap { filename = "stimuli\\Empty.jpg"; }; x=0;y=100;} Empty;

# braucht man das extra?? ja in der vas skala
bitmap { filename = "stimuli\\Quadrat.jpg"; } Figure_1; 
bitmap { filename = "stimuli\\Rechteck.jpg"; } Figure_2;
bitmap { filename = "stimuli\\Raute.jpg"; } Figure_3;

bitmap { filename = "stimuli\\Instr_PainAdjust.jpg"; } INSTR_1;

#--------------
# Trials
#--------------

trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 1;
	
   picture {
      bitmap INSTR_1;
      x = 0; y = 0;
   };
}INSTRUCTION_TRIAL;

#--------------
# weisses Fixationskreuz
#--------------
picture{					
   text{ 
		caption = "+";
		font_size = 48;
	};
   x = 0; 
	y = 0;   
}CROSSHAIR; 


#--------------
# Anticipation pain trial
#--------------

/*
trial{
	trial_duration = $dur_trial; 
 
   stimulus_event{
      nothing {}; #black screen;
      time      = 0;									
      duration  = $dur_anticipation_pain;			
      code      = "ANTICIPATION_PAIN";
   }ANTICIPATION_US_EVENT;  
   
   stimulus_event{
      nothing {}; 
      time      = $dur_anticipation_pain;
      duration  = $dur_pain;
      code      = "PAIN";
      port_code = 255;    ## Achtung Port code einstellen!
   }US_EVENT; 
}ANTICIPATION_US_TRIAL;
*/

trial{
	trial_duration = stimuli_length; #$dur_trial; With stimili_length you do not need to define the trial duration in pcl
 
   stimulus_event{
      picture {};
		#picture PAUSE;
      time      = 0;				
      duration  = $dur_anticipation_pain;			
      code      = "ANTICIPATION_PAIN";
   }ANTICIPATION_US_EVENT;  
   
   stimulus_event{
      #nothing {};
		picture CROSSHAIR;
      #time      = $dur_anticipation_pain;
		time      = $time_pain_event;
      duration  = $dur_pain;
      code      = "PAIN";
      port_code = 255;    ## Achtung Port code einstellen!
   }US_EVENT; 

   stimulus_event{
		picture{};
		#picture PAUSE;
		time      = $time_pause_event;
		duration  = $dur_pause_event;
     code      = "PAUSE";  
  }PAUSE_EVENT;
}ANTICIPATION_US_TRIAL;


#--------------
# VAS_PAUSE_TRIAL
#--------------

/*
# set_duration(vas_jitter) - ins input-file schreiben
trial{
	trial_duration = $dur_pause_vas_trial;
   stimulus_event{
		picture {};#DEFAULT;
      code      = "PAUSE_VAS";  
   }PAUSE_VAS_EVENT;  
}PAUSE_VAS_TRIAL;
*/

#--------------
# ITI trial
#--------------

trial{
	trial_duration = stimuli_length;
   stimulus_event{
		picture {};
		duration  = $dur_iti;
      code      = "ITI";  
   }ITI_EVENT;  
}ITI_TRIAL;

#==================================================
#----------------VAS Stimulus Part-----------------
#==================================================

# define picture parts
# --------------------
box{                       
   height = 10;
   width  = 10;
   color  = 255, 0, 0;                
}Item;

box{ 
   height = 10;
   width  = 10;
   color  = 255, 255, 255;
}Delim;

text{ 
   caption    = "LeftLabel";
   font_color = 255, 255 ,255;
   font_size  = 14;
   text_align = align_center; 
}LLabel;

text{ 
   caption    = "MiddleLabel";
   font_color = 255,255,255;
   font_size  = 14;
   text_align = align_center; 
}MLabel;

text{ 
   caption    = "RightLabel";
   font_color = 255,255,255;
   font_size  = 14;
   text_align = align_center; 
}RLabel;

text {
   caption    = "Title";
   font_color = 255,255,255;
   font_size  = 18;
   text_align = align_center;
}STitle;

# assemble picture parts (numbered 1 to 5) into picture
# -----------------------------------------------------
picture{
   box Delim;   x = -100; y =  0;
   box Delim;   x =  -80; y =  0;
   box Delim;   x =  100; y =  0;
   text LLabel; x = -100; y = 30;
   text MLabel; x =  -80; y = 30;
   text RLabel; x =  100; y = 30;
   text STitle; x =    0; y = 50;
}VAS_Scale;

#==================================================
#------------------VAS Trial Part------------------                        
#================================================== 

trial{
   trial_duration = forever;
   trial_type     = first_response;
   all_responses  = true;
   stimulus_event{             
      picture VAS_Scale;
      code = "VAS";
   }FirstResponse_event;      
}FirstResponseScaling;

trial{                           
   trial_duration = 100;
   stimulus_event{
      picture VAS_Scale;      
   }Scale_event;
}Scaling;  

# WriteToLogFile is used for writing vascores to the terminal by changing the code
trial{
   trial_duration = 100;
   stimulus_event{
      picture {};#DEFAULT;
		code = "SCORE:";		
   }LogEvent;
}WriteToLogFile; 
