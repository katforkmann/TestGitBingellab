#=========================================================================
# Scenario file adjusted by marvdsch for capsaicin experiment (jan 2018)
# Major adjustments:
# 1. 	Experiments now includes 2 CS+: CSpain and CSrelief 
# 		and one CS-: no US
# 2. Oder is fixed (no shuffle) because the thermode has to be manually set.
# 3. removed MRI-emulation for behavioural experiment

# 4. reorganized the scripts: removed redundencies, use one VAS pcl file, build every trial as: 
#		stimulus presentations, reinforcement, set-question & VAS, write to logfiles
#=========================================================================


#==========================================
#------------SDL header part---------------
#==========================================

scenario = "fear_con_capsaicin_hab_acq_ext";
pcl_file = "fear_con_capsaicin_hab_acq_ext.pcl";   	

/*
scenario_type = fMRI_emulation;
pulse_code = 222;					
pulses_per_scan = 1;
scan_period = 2410;				#only during "scenario_type = fMRI_emulation" - auskommentieren
no_logfile = false;
*/

response_matching = simple_matching;
active_buttons    = 6;
button_codes      = 1000, 2000, 3000, 4000, 5000, 6000;
response_logging = log_active;

# 1 = space, 2 = <-- , 3 = --> 4 = enter, 5 = <-- (up), 6 = --> (up)
# 1 = G # 2 = B # 3 = Z # 4 = R # 5 = B(up) # 6 = Z(up) 

default_font_size = 40;
default_text_color = 255,255,255;
default_background_color  = 0, 0 ,0;

#auskommentieren, wenn ohne ports
response_port_output = false;   
write_codes          = true;   
pulse_width          = 20;

stimulus_properties = name, string, resp_type, number, resp_time, number;
event_code_delimiter = ":";

begin;

$dur_trial          			= 500;  
$dur_iti          			= 500;  
$dur_off_pain	  				= 500;  
$dur_off_default				= 500;  
#$dur_off_tone	  				= 500;  
#$dur_off_picture				= 500;  
$dur_off_picture_VAS		 	= 1000;  
$dur_pain						= 2500;  
#$dur_tone						= 2500;  
$dur_picture					= 500;  
$dur_delay_trial				= 500;    		# evtl hier runter gehen mit der zeit
$dur_vas_trial					= 500;
$dur_picture_VAS				= 500;  

#==========================================
#-----------------SDL part-----------------
#==========================================

#==========================================
#--------------Stimulus Part---------------
#==========================================

# Ende
picture{
	text{ 
		caption = "Vielen Dank für die Teilnahme!";
		font_size = 40;
	};
   x = 0; 	
	y = 0;
}END;

# Instruktionen
bitmap { filename = "stimuli\\Instr_Experiment.jpg"; } INSTR;	      # Beschreibung Experiment
bitmap { filename = "stimuli\\Instr_Habituation.jpg"; } INSTR_HAB;	# Beschreibung Experiment
bitmap { filename = "stimuli\\INSTR_1_EXP.jpg"; } INSTR_1_EXP;	# Beschreibung Experiment # noch anpassen

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


#--------------
# Trials
#--------------
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 1;
   picture {
      bitmap INSTR_HAB;
      x = 0; y = 0;
   };
}INSTRUCTION_HAB;

trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 1;
   picture {
      bitmap INSTR;
      x = 0; y = 0;
   };
}INSTRUCTION_TRIAL;

picture{					
   text{ 
		caption = "+";
		font_size = 48;
	};x = 0; y = 100;
}WHITE_CROSSHAIR; # marvdsch: put + higher on screen to match the picture?

trial{
	trial_duration = stimuli_length; #$dur_trial; 
   stimulus_event{
      picture WHITE_CROSSHAIR;
      time      = 0;				
      duration  = $dur_iti;			
      code      = "ITI";
   }ITI_EVENT;  
}ITI_TRIAL;


#--------------
# pain trial
#--------------

trial{  
	trial_duration = stimuli_length; #$dur_trial; #500
   stimulus_event{     
		nothing {}; #NULL;
      time      = 0;
      duration  = 1000; #$dur_pain; #2500
      code      = "US";
      port_code = 255;    
   }PAINSTIM_EVENT;
	stimulus_event{     
		picture Empty;
      time      = 1000;
      duration  = 1500;
      code      = "blackscreen_pain";   
   }BLACKSCREEN_PAIN;  
}PAINSTIM_TRIAL;

#--------------
# add relief trial??
#--------------

#trial{
#	#trial_duration = $dur_trial;
#	stimulus_event {
#		nothing{}; 
#		target_button = 1; 
#	} painbutton;
#}UCS_EVENT;

trial {} PAUSE_VAS_EVENT;

#--------------
# Nothing-Stimuli --> used for sending the portcodes to SCR (dummycode) and for logging information
#--------------
trial{
	trial_duration = 1; 
	stimulus_event {
		nothing{};
	} dummycode; 
}NOTHING;

#--------------
# CS minus Trial
#--------------
trial {stimulus_event{nothing{};} pic1; }CS_Minus;

#--------------
# CS Pain Trial
#--------------
trial {stimulus_event{nothing{};} pic2; } CS_Pain;

#--------------
# CS Relief Trial
#--------------
trial {stimulus_event{nothing{};} pic3;} CS_Relief; # marvdsch: included relief instead of tone

#--------------
# Delay trial
#--------------
#trial {trial_duration = 4000; } Delay;

trial{
	trial_duration = $dur_trial; 
	trial_type = fixed;
   stimulus_event{
      picture{}; #DEFAULT;
      code      = "EDA_DELAY";
   }EDA_DELAY_EVENT; 
}EDA_DELAY_TRIAL;

# fMRI-specific trials
#--------------
trial {                  
   trial_mri_pulse = 6; 		# Beginn wird getriggert durch Puls 6
   picture{}; #DEFAULT;
   code            = -1;
   duration        = 1;
} BEGIN_TRIAL;

trial{
	trial_duration = $dur_trial; 
	trial_type = fixed;
   stimulus_event{
      picture{}; # DEFAULT;
      code      = "START_FMRI";
   }START_FMRI_EVENT; 
}START_FMRI_TRIAL;

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

trial{
   trial_duration = 100;
   
   stimulus_event{
		nothing{};
      #picture{};# DEFAULT;
   }LogEvent;
   
}WriteToLogFile; 

