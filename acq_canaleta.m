function varargout = acq_canaleta(varargin)
% ACQ_CANALETA MATLAB code for acq_canaleta.fig
%      ACQ_CANALETA, by itself, creates a new ACQ_CANALETA or raises the existing
%      singleton*.
%
%      H = ACQ_CANALETA returns the handle to a new ACQ_CANALETA or the handle to
%      the existing singleton*.
%
%      ACQ_CANALETA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ACQ_CANALETA.M with the given input arguments.
%
%      ACQ_CANALETA('Property','Value',...) creates a new ACQ_CANALETA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before acq_canaleta_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to acq_canaleta_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help acq_canaleta

% Last Modified by GUIDE v2.5 02-Aug-2021 12:03:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @acq_canaleta_OpeningFcn, ...
                   'gui_OutputFcn',  @acq_canaleta_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before acq_canaleta is made visible.
function acq_canaleta_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to acq_canaleta (see VARARGIN)

% Choose default command line output for acq_canaleta
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes acq_canaleta wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global menu var
devices = daq.getDevices;
ndi=size(devices,2);
var.daqactive=[0,0];
u_ni=uicontrol('Style', 'radiobutton','Position', [10, 10, 80, 22],'BackgroundColor','white', ...
            'units','normalized','String','NI', 'FontSize',10,'position',[0.37 0.01 0.05 0.03], 'Value',0,'Enable','inactive');
u_mcc=uicontrol('Style', 'radiobutton','Position', [10, 10, 80, 22],'BackgroundColor','white', ...
            'units','normalized','String','MCC', 'FontSize',10,'position',[0.41 0.01 0.1 0.03], 'Value',0,'Enable','inactive');
        
if ndi==2
    set(u_ni,'Value',1)
    set(u_mcc,'Value',1)
    var.daqactive=[1,1];
elseif ndi==1
	ven=devices(1).Vendor;
	if strcmp(ven.ID,'ni')
        set(u_ni,'Value',1)
        var.daqactive=[1,0];
    else
        set(u_mcc,'Value',1)
        var.daqactive=[0,1];
	end
end

var.save=0;      
var.run=0;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% PANEL CAPTURE    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
menu.panel_capture = uipanel('Title','','FontSize',12,...
             'BackgroundColor','white','units','normalized',...
             'Position',[0.01 .018 .30 .944],'HighLightColor',[0.8500 0.3250 0.0980],...
             'ShadowColor',[0.8500 0.3250 0.0980],'BorderWidth',2);

menu.id=uicontrol(menu.panel_capture,'Style','text','string','ID','units','normalized',...
    'BackgroundColor','white','FontSize',12,'position',[0.01 0.9 0.25 0.05]);
var.id=clock;
var.id=['Experiment_',num2str(var.id(1)),'_',num2str(var.id(2)),'_',num2str(var.id(3)),'_',num2str(var.id(4)),'_',num2str(var.id(5))];
menu.id=uicontrol(menu.panel_capture,'Style','edit','string',var.id,'units','normalized','position',[0.28 0.9 0.6 0.05],'CallBack', {@edit_id_Callback,handles});

var.date=clock;
var.date=[num2str(var.date(3)),'-',num2str(var.date(2)),'-',num2str(var.date(1)),'_',num2str(var.date(4)),':',num2str(var.date(5)),':',num2str(round(var.date(6)))];
menu.date_t=uicontrol(menu.panel_capture,'Style','text','string','Date','units','normalized',...
    'BackgroundColor','white','FontSize',12,'position',[0.01 0.81 0.25 0.05]);
menu.date_e=uicontrol(menu.panel_capture,'Style','edit','string',var.date,'units','normalized','position',[0.28 0.81 0.6 0.05],'CallBack', {@edit_date_Callback,handles});
         
menu.time_t=uicontrol(menu.panel_capture,'Style','text','string','Time (s)','units','normalized',...
    'BackgroundColor','white','FontSize',12,'position',[0.01 0.72 0.2 0.05]);
menu.time_e=uicontrol(menu.panel_capture,'Style','edit','string','5','units','normalized','position',[0.28 0.72 0.2 0.05],'CallBack', {@edit_time_Callback,handles});
var.time=5;


menu.peso_t=uicontrol(menu.panel_capture,'Style','text','string','Peso (kg)','units','normalized',...
    'BackgroundColor','white','FontSize',12,'position',[0.01 0.63 0.25 0.05]);
var.peso=0;
menu.peso_e=uicontrol(menu.panel_capture,'Style','edit','string',num2str(var.peso),'units','normalized','position',[0.28 0.63 0.2 0.05],'CallBack', {@edit_peso_Callback,handles});

menu.angulof_t=uicontrol(menu.panel_capture,'Style','text','string','Ang_fri','units','normalized',...
    'BackgroundColor','white','FontSize',12,'position',[0.01 0.54 0.25 0.05]);
var.angulof=0;
menu.angulof_e=uicontrol(menu.panel_capture,'Style','edit','string',num2str(var.angulof),'units','normalized','position',[0.28 0.54 0.2 0.05],'CallBack', {@edit_angulof_Callback,handles});

menu.angulor_t=uicontrol(menu.panel_capture,'Style','text','string','Ang_rep','units','normalized',...
    'BackgroundColor','white','FontSize',12,'position',[0.01 0.45 0.25 0.05]);
var.angulor=0;
menu.angulor_e=uicontrol(menu.panel_capture,'Style','edit','string',num2str(var.angulor),'units','normalized','position',[0.28 0.45 0.2 0.05],'CallBack', {@edit_angulor_Callback,handles});


%%%%%
menu.vol_t=uicontrol(menu.panel_capture,'Style','text','string','Vol (cm3)','units','normalized',...
    'BackgroundColor','white','FontSize',12,'position',[0.01 0.36 0.25 0.05]);
var.vol=0;
menu.vol_e=uicontrol(menu.panel_capture,'Style','edit','string',num2str(var.vol),'units','normalized','position',[0.28 0.36 0.2 0.05],'CallBack', {@edit_vol_Callback,handles});
%%%%%
menu.temp_t=uicontrol(menu.panel_capture,'Style','text','string','Temp','units','normalized',...
    'BackgroundColor','white','FontSize',12,'position',[0.01 0.27 0.25 0.05]);
var.temp=0;
menu.temp_e=uicontrol(menu.panel_capture,'Style','edit','string',num2str(var.temp),'units','normalized','position',[0.28 0.27 0.2 0.05],'CallBack', {@edit_temp_Callback,handles});
%%%%%%%

menu.grano_t=uicontrol(menu.panel_capture,'Style','text','string',['-5', char(hex2dec('03D5')),' to ','5', char(hex2dec('03D5')) ],'units','normalized',...
    'BackgroundColor','white','FontSize',12,'position',[0.01 0.18 0.25 0.05]);
var.grano=[0,0,0,0,0,0,0,0,0,0,0];
menu.grano_e=uicontrol(menu.panel_capture,'Style','edit','string',num2str(var.grano),'units','normalized','position',[0.28 0.18 0.6 0.05],'CallBack', {@edit_grano_Callback,handles});

%%%%%%%

menu.run=uicontrol(menu.panel_capture,'Style','pushbutton','units','normalized','String','',...
    'BackgroundColor','white','ForegroundColor',[0.8500 0.3250 0.0980], 'FontSize',10,'units','normalized',...
    'position',[0.4 0.05  0.2 0.1], 'FontWeight', 'Bold',...
    'CallBack', {@run_Callback,handles});

% si=get(menu.tab_export,'Position');
% si=si(3:4);
a=imread('play.jpg');
a=imresize(a,[30,30]);
set(menu.run,'CData',a);
% set(menu.tab_export,'units','normalized')



%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
%%%%%%%%%%%%%% PANEL GRAPH     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
menu.panel_graph = uipanel('Title','','FontSize',12,...
             'BackgroundColor','white','units','normalized',...
             'Position',[0.01 .018  .30 .944],'HighLightColor',[0.8500 0.3250 0.0980],...
             'ShadowColor',[0.8500 0.3250 0.0980],'BorderWidth',2, 'visible','off');
menu.laser1=uicontrol(menu.panel_graph,'Style','checkbox','String','Laser 1','Value', 1,...
    'BackgroundColor','white','FontSize',10,'units','normalized','position',[0.1 0.92 0.3 0.05]);
menu.laser2=uicontrol(menu.panel_graph,'Style','checkbox','String','Laser 2','Value', 1,...
    'BackgroundColor','white','FontSize',10,'units','normalized','position',[0.1 0.87 0.3 0.05]);
menu.laser3=uicontrol(menu.panel_graph,'Style','checkbox','String','Laser 3','Value', 1,...
    'BackgroundColor','white','FontSize',10,'units','normalized','position',[0.1 0.82 0.3 0.05]);
menu.laser4=uicontrol(menu.panel_graph,'Style','checkbox','String','Laser 4','Value', 1,...
    'BackgroundColor','white','FontSize',10,'units','normalized','position',[0.1 0.77 0.3 0.05]);
menu.laser5=uicontrol(menu.panel_graph,'Style','checkbox','String','Laser 5','Value', 1,...
    'BackgroundColor','white','FontSize',10,'units','normalized','position',[0.1 0.72 0.3 0.05]);
menu.laser6=uicontrol(menu.panel_graph,'Style','checkbox','String','Laser 6','Value', 1,...
    'BackgroundColor','white','FontSize',10,'units','normalized','position',[0.1 0.67 0.3 0.05]);
menu.laser7=uicontrol(menu.panel_graph,'Style','checkbox','String','Laser 7','Value', 1,...
    'BackgroundColor','white','FontSize',10,'units','normalized','position',[0.1 0.62 0.3 0.05]);
menu.laser8=uicontrol(menu.panel_graph,'Style','checkbox','String','Laser 8','Value', 1,...
    'BackgroundColor','white','FontSize',10,'units','normalized','position',[0.1 0.57 0.3 0.05]);
menu.laser9=uicontrol(menu.panel_graph,'Style','checkbox','String','Laser 9','Value', 1,...
    'BackgroundColor','white','FontSize',10,'units','normalized','position',[0.1 0.52 0.3 0.05]);
menu.laser10=uicontrol(menu.panel_graph,'Style','checkbox','String','Laser 10','Value', 1,...
    'BackgroundColor','white','FontSize',10,'units','normalized','position',[0.1 0.47 0.3 0.05]);
menu.laser11=uicontrol(menu.panel_graph,'Style','checkbox','String','Laser 11','Value', 1,...
    'BackgroundColor','white','FontSize',10,'units','normalized','position',[0.1 0.42 0.3 0.05]);
menu.laser12=uicontrol(menu.panel_graph,'Style','checkbox','String','Laser 12','Value', 1,...
    'BackgroundColor','white','FontSize',10,'units','normalized','position',[0.1 0.37 0.3 0.05]);
menu.laser13=uicontrol(menu.panel_graph,'Style','checkbox','String','Laser 13','Value', 1,...
    'BackgroundColor','white','FontSize',10,'units','normalized','position',[0.1 0.32 0.3 0.05]);
menu.laser14=uicontrol(menu.panel_graph,'Style','checkbox','String','Laser 14','Value', 1,...
    'BackgroundColor','white','FontSize',10,'units','normalized','position',[0.1 0.27 0.3 0.05]);
menu.celda1=uicontrol(menu.panel_graph,'Style','checkbox','String','Celda 1','Value', 1,...
    'BackgroundColor','white','FontSize',10,'units','normalized','position',[0.1 0.22 0.3 0.05]);
menu.celda2=uicontrol(menu.panel_graph,'Style','checkbox','String','Celda 2','Value', 1,...
    'BackgroundColor','white','FontSize',10,'units','normalized','position',[0.1 0.17 0.3 0.05]);
menu.celda3=uicontrol(menu.panel_graph,'Style','checkbox','String','Celda 3','Value', 1,...
    'BackgroundColor','white','FontSize',10,'units','normalized','position',[0.1 0.12 0.3 0.05]);
menu.celda4=uicontrol(menu.panel_graph,'Style','checkbox','String','Celda 4','Value', 1,...
    'BackgroundColor','white','FontSize',10,'units','normalized','position',[0.1 0.07 0.3 0.05]);
menu.celda5=uicontrol(menu.panel_graph,'Style','checkbox','String','Celda 5','Value', 1,...
    'BackgroundColor','white','FontSize',10,'units','normalized','position',[0.1 0.02 0.3 0.05]);

menu.geofono1=uicontrol(menu.panel_graph,'Style','checkbox','String','Geofono 1','Value', 1,...
    'BackgroundColor','white','FontSize',10,'units','normalized','position',[0.5 0.92 0.3 0.05]);
menu.geofono2=uicontrol(menu.panel_graph,'Style','checkbox','String','Geofono 2','Value', 1,...
    'BackgroundColor','white','FontSize',10,'units','normalized','position',[0.5 0.87 0.3 0.05]);
menu.geofono3=uicontrol(menu.panel_graph,'Style','checkbox','String','Geofono 3','Value', 1,...
    'BackgroundColor','white','FontSize',10,'units','normalized','position',[0.5 0.82 0.3 0.05]);

menu.hCheckboxes = [menu.laser1; menu.laser2;menu.laser3; menu.laser4;menu.laser5; menu.laser6;...
     menu.laser7; menu.laser8;menu.laser9; menu.laser10;menu.laser11; menu.laser12;...
     menu.laser13; menu.laser14];
 
menu.hCheckboxes2 = [menu.celda1; menu.celda2;menu.celda3; menu.celda4;...
     menu.celda5; menu.geofono1;menu.geofono2; menu.geofono3];


menu.select=uicontrol(menu.panel_graph,'Style','pushbutton','units','normalized','String','Deselect all',...
    'BackgroundColor','white','ForegroundColor',[0.8500 0.3250 0.0980], 'FontSize',10,'units','normalized',...
    'position',[0.45 0.35 0.3 0.05], 'FontWeight', 'Bold',...
    'CallBack', {@select_Callback,handles});

menu.plot=uicontrol(menu.panel_graph,'Style','pushbutton','units','normalized','String','Graph',...
    'BackgroundColor','white','ForegroundColor',[0.8500 0.3250 0.0980], 'FontSize',10,'units','normalized',...
    'position',[0.45 0.25 0.3 0.05], 'FontWeight', 'Bold',...
    'CallBack', {@graph_b_Callback,handles});



menu.xmin_t=uicontrol(menu.panel_graph,'Style','text','string','x min','units','normalized',...
    'BackgroundColor','white','FontSize',10,'position',[0.45 0.66 0.13 0.09]);
menu.xmin_e=uicontrol(menu.panel_graph,'Style','edit','string','-','units','normalized','position',[0.45 0.659 0.13 0.05],'CallBack',{@limits_Callback,handles});
var.xmin=[];

menu.xmax_t=uicontrol(menu.panel_graph,'Style','text','string','x max','units','normalized',...
    'BackgroundColor','white','FontSize',10,'position',[0.65 0.66 0.13 0.09]);
menu.xmax_e=uicontrol(menu.panel_graph,'Style','edit','string','-','units','normalized','position',[0.65 0.659 0.13 0.05],'CallBack',{@limits_Callback,handles});
var.xmax=[];

menu.ymin_t=uicontrol(menu.panel_graph,'Style','text','string','y min','units','normalized',...
    'BackgroundColor','white','FontSize',10,'position',[0.45  0.5 0.13 0.09]);
menu.ymin_e=uicontrol(menu.panel_graph,'Style','edit','string','-','units','normalized','position',[0.45 0.499 0.13 0.05],'CallBack',{@limits_Callback,handles});
var.ymin=[];
menu.ymax_t=uicontrol(menu.panel_graph,'Style','text','string','y max','units','normalized',...
    'BackgroundColor','white','FontSize',10,'position',[0.65 0.5 0.13 0.09]);
menu.ymax_e=uicontrol(menu.panel_graph,'Style','edit','string','-','units','normalized','position',[0.65 0.499 0.13 0.05],'CallBack',{@limits_Callback,handles});
var.ymax=[];
%%%%%%%%%%%%%% PANEL EXPORT 
menu.panel_export = uipanel('Title','','FontSize',12,...
             'BackgroundColor','white','units','normalized',...
             'Position',[0.01 .018 .30 .944],'HighLightColor',[0.8500 0.3250 0.0980],...
             'ShadowColor',[0.8500 0.3250 0.0980],'BorderWidth',2, 'visible','off');
         
menu.savep=uicontrol(menu.panel_export,'Style','pushbutton','units','normalized','String','Guardar proyecto',...
    'BackgroundColor','white','ForegroundColor',[0.8500 0.3250 0.0980], 'FontSize',12,'units','normalized',...
    'position',[0.25 0.3 0.5 0.105], 'FontWeight', 'Bold',...
    'CallBack', {@save_project_Callback,handles});

 menu.saveg=uicontrol(menu.panel_export,'Style','pushbutton','units','normalized','String','Guardar graficas',...
    'BackgroundColor','white','ForegroundColor',[0.8500 0.3250 0.0980], 'FontSize',12,'units','normalized',...
    'position',[0.25 0.5 0.5 0.105], 'FontWeight', 'Bold',...
    'CallBack', {@save_graph_Callback,handles});    

 menu.saved=uicontrol(menu.panel_export,'Style','pushbutton','units','normalized','String','Guardar datos',...
    'BackgroundColor','white','ForegroundColor',[0.8500 0.3250 0.0980], 'FontSize',12,'units','normalized',...
    'position',[0.25 0.7 0.5 0.105], 'FontWeight', 'Bold',...
    'CallBack', {@save_data_Callback,handles});           
  
%%%%%%%%%%%%%% Export tab
menu.tab_export=uicontrol('units','normalized','Style','pushbutton','String','Save',...
             'Position',[.215 .95 .08 .05],'FontSize',11,...
             'BackgroundColor','white',...
             'ForegroundColor',[0.254 0.529 0.568],...
             'Enable','on','CallBack', {@export_Callback,handles});
jh = findjobj(menu.tab_export);
jh.Border = [];
jh.setFlyOverAppearance(true);
jh.setBorderPainted(false);    
jh.setContentAreaFilled(false);

set(menu.tab_export,'units','pixels')
si=get(menu.tab_export,'Position');
si=si(3:4);
a=imread('tab.jpg');
a=imresize(a,[si(2)-7,si(1)]);
set(menu.tab_export,'CData',a);
set(menu.tab_export,'units','normalized')

%%%%%%%%%%%%%% Capture tab
menu.tab_capture=uicontrol('units','normalized','Style','pushbutton','String','Capture',...
             'Position',[.022 .95 .08 .05],'FontSize',10, 'FontWeight', 'Bold',...
             'BackgroundColor','white',...
             'ForegroundColor',[0.2 0.28 0.4],...
             'Enable','on','CallBack', {@capture_Callback,handles});
jh = findjobj(menu.tab_capture);
jh.Border = [];
jh.setFlyOverAppearance(true);
jh.setBorderPainted(false);    
jh.setContentAreaFilled(false);
set(menu.tab_capture,'units','pixels')
a=imresize(a,[si(2)-7,si(1)]);
set(menu.tab_capture,'CData',a);
set(menu.tab_capture,'units','normalized')

%%%%%%%%%%%%%% Graph tab
menu.tab_graph=uicontrol('units','normalized','Style','pushbutton','String','Graphs',...
             'Position',[.119 .95 .08 .05],'FontSize',10,...
             'BackgroundColor','white',...
             'ForegroundColor',[0.254 0.529 0.568],...
             'Enable','on','CallBack', {@graph_Callback,handles});
jh = findjobj(menu.tab_graph);
jh.Border = [];
jh.setFlyOverAppearance(true);
jh.setBorderPainted(false);    
jh.setContentAreaFilled(false);
set(menu.tab_graph,'units','pixels')
a=imresize(a,[si(2)-7,si(1)]);
set(menu.tab_graph,'CData',a);
set(menu.tab_graph,'units','normalized')

menu.ax1 = axes('units','normalized','Position',[0.35 0.1 0.63 0.85],'Box','on');

menu.text_run=uicontrol(menu.panel_capture,'Style','text','string','start mcc','units','normalized',...
    'BackgroundColor','white','FontSize',12,'position',[0.01 0.01 0.25 0.05],'visible','off');



% --- Outputs from this function are returned to the command line.
function varargout = acq_canaleta_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function capture_Callback(hObject, eventdata, handles)
global menu
set(menu.tab_capture,'ForegroundColor',[0.2 0.28 0.4],'FontSize',11,'FontWeight', 'Bold')
set(menu.tab_graph,'ForegroundColor',[0.254 0.529 0.568],'FontSize',10,'FontWeight', 'normal')
set(menu.tab_export,'ForegroundColor',[0.254 0.529 0.568],'FontSize',10,'FontWeight', 'normal')
set(menu.panel_capture,'visible','on')
set(menu.panel_graph,'visible','off')
set(menu.panel_export,'visible','off')

function graph_Callback(hObject, eventdata, handles)
global menu
set(menu.tab_graph,'ForegroundColor',[0.2 0.28 0.4],'FontSize',11,'FontWeight', 'Bold')
set(menu.tab_export,'ForegroundColor',[0.254 0.529 0.568],'FontSize',10,'FontWeight', 'normal')
set(menu.tab_capture,'ForegroundColor',[0.254 0.529 0.568],'FontSize',10,'FontWeight', 'normal')
set(menu.panel_capture,'visible','off')
set(menu.panel_graph,'visible','on')
set(menu.panel_export,'visible','off')

function export_Callback(hObject, eventdata, handles)
global menu
set(menu.tab_export,'ForegroundColor',[0.2 0.28 0.4],'FontSize',11,'FontWeight', 'Bold')
set(menu.tab_graph,'ForegroundColor',[0.254 0.529 0.568],'FontSize',10,'FontWeight', 'normal')
set(menu.tab_capture,'ForegroundColor',[0.254 0.529 0.568],'FontSize',10,'FontWeight', 'normal')
set(menu.panel_capture,'visible','off')
set(menu.panel_graph,'visible','off')
set(menu.panel_export,'visible','on')

function select_Callback(hObject, eventdata, handles)
global menu
st=get(menu.select,'String');
if strcmpi(st,'Deselect all')
 set(menu.select,'String','Select all')
 set(menu.hCheckboxes,'value',0)
 set(menu.hCheckboxes2,'value',0)
else
set(menu.select,'String','Deselect all')
 set(menu.hCheckboxes,'value',1)
 set(menu.hCheckboxes2,'value',1)
end

function graph_b_Callback(hObject, eventdata, handles)
global menu var
status1=get(menu.hCheckboxes,'value');
status1=cell2mat(status1);
status2=get(menu.hCheckboxes2,'value');
status2=cell2mat(status2);
cla(menu.ax1,'reset')
hold(menu.ax1, 'on' )
for i=1:length(status1)
    if status1(i)==1
    plot(var.tiempo_mcc,var.data_mcc(:,i))
    end
end

for i=1:length(status2)
    if status2(i)==1
    plot(var.tiempo_ni,var.data_ni(:,i))
    end
end
xl=get(menu.ax1,'xlim');
yl=get(menu.ax1,'ylim');
set(menu.xmin_e,'string',num2str(xl(1)))
set(menu.xmax_e,'string',num2str(xl(2)))
set(menu.ymin_e,'string',num2str(yl(1)))
set(menu.ymax_e,'string',num2str(yl(2)))
xlabel('Time (s)')
ylabel('Voltage (V)')

function limits_Callback(hObject, eventdata, handles)
global menu var
% xl=get(menu.ax1,'xlim');
% yl=get(menu.ax1,'ylim');
try
var.xmin=str2double(get(menu.xmin_e,'string'));
var.xmax=str2double(get(menu.xmax_e,'string'));
var.ymin=str2double(get(menu.ymin_e,'string'));
var.ymax=str2double(get(menu.ymax_e,'string'));
set(menu.ax1,'xlim',[var.xmin,var.xmax]);
set(menu.ax1,'ylim',[var.ymin,var.ymax]);
catch
    
end

function edit_id_Callback(hObject, eventdata, handles)
global menu var
var.id=get(menu.id,'String');

function edit_time_Callback(hObject, eventdata, handles)
global menu var
var.time=str2double(get(menu.time_e,'String'));

function edit_date_Callback(hObject, eventdata, handles)
global menu var
var.date=get(menu.date_e,'String');

function edit_peso_Callback(hObject, eventdata, handles)
global menu var
var.peso=str2double(get(menu.peso_e,'String'));

function edit_vol_Callback(hObject, eventdata, handles)
global menu var
var.vol=str2double(get(menu.vol_e,'String'));

function edit_temp_Callback(hObject, eventdata, handles)
global menu var
var.temp=str2double(get(menu.temp_e,'String'));

function edit_angulor_Callback(hObject, eventdata, handles)
global menu var
var.angulor=str2double(get(menu.angulor_e,'String'));

function edit_angulof_Callback(hObject, eventdata, handles)
global menu var
var.angulof=str2double(get(menu.angulof_e,'String'));

function edit_grano_Callback(hObject, eventdata, handles)
global menu var
var.grano= str2num(get(menu.grano_e,'String'));

function run_Callback(hObject, eventdata, handles)
global var datos menu
% var.data_mcc=randi([0,1],20483,14);
% var.data_ni=rand(20480,8);
var.save=0;
var.run=1;
if var.daqactive(1)==1 && var.daqactive(2)==1   
datos=[];
s = daq.createSession('mcc');
s2 = daq.createSession('mcc');
sd = daq.createSession('ni');
s.DurationInSeconds = 5;
s.Rate = 4096;
sd.DurationInSeconds = 5;
sd.Rate = 4096;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%Canales de MCC
channel1 = addAnalogInputChannel(s,"Board0", "Ai0", "Voltage");
channel1.TerminalConfig = 'SingleEnded';
channel2 = addAnalogInputChannel(s,"Board0", "Ai1", "Voltage");
channel2.TerminalConfig = 'SingleEnded';
channel3 = addAnalogInputChannel(s,"Board0", "Ai2", "Voltage");
channel3.TerminalConfig = 'SingleEnded';
channel4 = addAnalogInputChannel(s,"Board0", "Ai3", "Voltage");
channel4.TerminalConfig = 'SingleEnded';
channel5 = addAnalogInputChannel(s,"Board0", "Ai4", "Voltage");
channel5.TerminalConfig = 'SingleEnded';
channel6 = addAnalogInputChannel(s,"Board0", "Ai5", "Voltage");
channel6.TerminalConfig = 'SingleEnded';
channel7 = addAnalogInputChannel(s,"Board0", "Ai6", "Voltage");
channel7.TerminalConfig = 'SingleEnded';
channel8 = addAnalogInputChannel(s,"Board0", "Ai7", "Voltage");
channel8.TerminalConfig = 'SingleEnded';
channel9 = addAnalogInputChannel(s,"Board0", "Ai8", "Voltage");
channel9.TerminalConfig = 'SingleEnded';
channel10 = addAnalogInputChannel(s,"Board0", "Ai9", "Voltage");
channel10.TerminalConfig = 'SingleEnded';
channel11 = addAnalogInputChannel(s,"Board0", "Ai10", "Voltage");
channel11.TerminalConfig = 'SingleEnded';
channel12 = addAnalogInputChannel(s,"Board0", "Ai11", "Voltage");
channel12.TerminalConfig = 'SingleEnded';
channel13 = addAnalogInputChannel(s,"Board0", "Ai12", "Voltage");
channel13.TerminalConfig = 'SingleEnded';
channel14 = addAnalogInputChannel(s,"Board0", "Ai13", "Voltage");
channel14.TerminalConfig = 'SingleEnded';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%Canales de NI
channel1d = addAnalogInputChannel(sd,'Dev1','ai0','Voltage');
channel1d.TerminalConfig = 'SingleEnded';
channel2d = addAnalogInputChannel(sd,'Dev1','ai1','Voltage');
channel2d.TerminalConfig = 'SingleEnded';
channel3d = addAnalogInputChannel(sd,'Dev1','ai2','Voltage');
channel3d.TerminalConfig = 'SingleEnded';
channel4d = addAnalogInputChannel(sd,'Dev1','ai3','Voltage');
channel4d.TerminalConfig = 'SingleEnded';
channel5d = addAnalogInputChannel(sd,'Dev1','ai4','Voltage');
channel5d.TerminalConfig = 'SingleEnded';
channel6d = addAnalogInputChannel(sd,'Dev1','ai5','Voltage');
channel6d.TerminalConfig = 'SingleEnded';
channel7d = addAnalogInputChannel(sd,'Dev1','ai6','Voltage');
channel7d.TerminalConfig = 'SingleEnded';
channel8d = addAnalogInputChannel(sd,'Dev1','ai7','Voltage');
channel8d.TerminalConfig = 'SingleEnded';
channel9d = addAnalogInputChannel(sd,'Dev1','ai8','Voltage');
channel9d.TerminalConfig = 'SingleEnded';
%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Trigger
addAnalogOutputChannel(s2,"Board0",'Ao0','Voltage');

%%%%%%%%%%%% Wait time
sd.ExternalTriggerTimeout = 100;

%%%%%%%%%%%% Write false in trigger
outputSingleScan(s2,0);

%%%%Trigger configuration
addTriggerConnection(sd,'external','Dev1/PFI1','StartTrigger');

%%%%Background capture configuration
addlistener(sd,'DataAvailable',@getData); 

%%%%start MCC
startBackground(sd);
pause(1)

%%%%%%%%%%%% Write True in trigger
outputSingleScan(s2,4)
set(menu.text_run,'visible','on')
% fprintf('start mcc')

%%%%start NI
[var.data_mcc, Time, ~] =startForeground(s);
var.tiempo_mcc=Time;
%%Wait NI capture
while(~s.IsDone)
end
var.data_ni = getGlobalx;


[r,lag] = xcorr(var.data_mcc(:,1),var.data_ni(:,9));
[~,I] = max(r);
t = lag(I); 
var.data_ni=var.data_ni(abs(t):end,:);
try
var.tiempo_ni=Time(1:length(var.data_ni));
catch
var.tiempo_ni=linspace(0,Time(end),length(var.data_ni));   
end
axes(menu.ax1)
plot(var.tiempo_ni,var.data_ni(:,9),'r')
hold on
plot(var.tiempo_mcc,var.data_mcc(:,1),'b')

%%% Remove channels 
removeChannel(s,[1,2]);
removeChannel(s2,1);
set(menu.text_run,'visible','off')        
else
d=warndlg('No hya tarjetas conectadas, se correra un DEMO','Warning');
var.data_mcc=randi([0,1],500,14);
var.data_ni=rand(500,9); 
var.tiempo_ni=linspace(0,5,500)';
var.tiempo_mcc=linspace(0,5,500)';
pause(2)
axes(menu.ax1)
plot(var.tiempo_ni,var.data_ni(:,9),'r')
try
close(d)
catch
end
end

function save_data_Callback(hObject, eventdata, handles)
global var
if var.run==0
    warndlg('No hay datos para guardar','Warning');
else
    var.save=1;
    Data1 = table(var.tiempo_mcc,var.data_mcc(:,1),var.data_mcc(:,2),var.data_mcc(:,3),var.data_mcc(:,4),var.data_mcc(:,5),...
        var.data_mcc(:,6),var.data_mcc(:,7),var.data_mcc(:,8),var.data_mcc(:,9),var.data_mcc(:,10),var.data_mcc(:,11)...
        ,var.data_mcc(:,12),var.data_mcc(:,13),var.data_mcc(:,14));
    Data1.Properties.VariableNames={'Tiempo','Laser_1','Laser_2','Laser_3','Laser_4','Laser_5','Laser_6','Laser_7','Laser_8',...
    'Laser_9','Laser_10','Laser_11','Laser_12','Laser_13','Laser_14'};
    Data2 = table(var.tiempo_ni,var.data_ni(:,1),var.data_ni(:,2),var.data_ni(:,3),var.data_ni(:,4),var.data_ni(:,5),...
        var.data_ni(:,6),var.data_ni(:,7),var.data_ni(:,8));
    Data2.Properties.VariableNames={'Tiempo','Celda_1','Celda_2','Celda_3','Celda_4','Celda_5','Geofono_1','Geofono_2','Geofono_3'};
    Data3 = table({'Id:';'Fecha:'; 'Tiempo de cap.'; 'Peso:'; 'Angulo de frcción:';...
        'Ángulo de reposo:';'Volumen (cm3):'; 'Temperatura:';'Distribución'},...
    {var.id;var.date;var.time;var.peso;var.angulof;var.angulor;var.vol;var.temp;var.grano});
    [file_e,path_e]=uiputfile({'*.xlsx'},'Select path and File');
    
    if file_e~=0
        d = waitbar(0.2,'Espere,guardando datos');
        var.file_e=[path_e,'Digitales_',file_e];
        var.path=path_e;
        writetable(Data1,var.file_e);
        waitbar(0.3,d,'Espere,guardando datos');
        var.file_e=[path_e,'Analogos_',file_e];
        writetable(Data2,var.file_e);
        waitbar(0.7,d,'Espere,guardando datos');
        var.file_e=[path_e,'Datos_',file_e];
        writetable(Data3,var.file_e);
        
        waitbar(1,d,'Listo');
        pause(1)
        close(d)
    end
    
end

function save_graph_Callback(hObject, eventdata, handles)
global var
if var.run==0
warndlg('No hay datos para guardar','Warning');
else
var.save=1;

path_e=uigetdir('Select folder');
if path_e~=0
    var.path=path_e;
[~,nf]=size(var.data_mcc);
[~,nf2]=size(var.data_ni);
nombre={'Laser 1','Laser 2','Laser 3','Laser 4','Laser 5','Laser 6','Laser 7','Laser 8',...
    'Laser 9','Laser 10','Laser 11','Laser 12','Laser 13','Laser 14'};

nombre2={'Celda 1','Celda 2','Celda 3','Celda 4','Celda 5','Geofono 1','Geofono 2','Geofono 3'};
d=figure('color','white','units','normalize');
set(gcf,'position',[0.1    0.1   0.8    0.8])

for i=1:nf
    plot(var.tiempo_mcc, var.data_mcc(:,i))
    title(nombre{i})
    xlabel('Time (s)')
    ylabel('Voltage (V)')
    print(d,[path_e,'\',nombre{i},'.png'],'-dpng','-r300');
end

for i=1:nf2-1
    plot(var.tiempo_ni, var.data_ni(:,i))
    title(nombre2{i})
    xlabel('Time (s)')
    ylabel('Voltage (V)')
    print(d,[path_e,'\',nombre2{i},'.png'],'-dpng','-r300');
end

close(d)
d = waitbar(1,'Listo');
pause(1)
close(d)  
end


end

function save_project_Callback(hObject, eventdata, handles)
global var 
if var.run==0
    warndlg('No hay datos para guardar','Warning');
else
    var.save=1;
    Data1 = table(var.tiempo_mcc,var.data_mcc(:,1),var.data_mcc(:,2),var.data_mcc(:,3),var.data_mcc(:,4),var.data_mcc(:,5),...
        var.data_mcc(:,6),var.data_mcc(:,7),var.data_mcc(:,8),var.data_mcc(:,9),var.data_mcc(:,10),var.data_mcc(:,11)...
        ,var.data_mcc(:,12),var.data_mcc(:,13),var.data_mcc(:,14));
    Data1.Properties.VariableNames={'Tiempo','Laser_1','Laser_2','Laser_3','Laser_4','Laser_5','Laser_6','Laser_7','Laser_8',...
    'Laser_9','Laser_10','Laser_11','Laser_12','Laser_13','Laser_14'};
    Data2 = table(var.tiempo_ni,var.data_ni(:,1),var.data_ni(:,2),var.data_ni(:,3),var.data_ni(:,4),var.data_ni(:,5),...
        var.data_ni(:,6),var.data_ni(:,7),var.data_ni(:,8));
    Data2.Properties.VariableNames={'Tiempo','Celda_1','Celda_2','Celda_3','Celda_4','Celda_5','Geofono_1','Geofono_2','Geofono_3'};
    Data3 = table({'Id:';'Fecha:'; 'Tiempo de cap.'; 'Peso:'; 'Angulo de frcción:';...
        'Ángulo de reposo:';'Volumen (cm3):'; 'Temperatura:';'Distribución'},...
    {var.id;var.date;var.time;var.peso;var.angulof;var.angulor;var.vol;var.temp;var.grano});
    [file_e,path_e]=uiputfile({'*.xlsx'},'Select path and File');
    
    if file_e~=0
        d = waitbar(0.2,'Espere,guardando datos');
        var.file_e=[path_e,file_e];
        var.path=path_e;
        writetable(Data1,var.file_e,'Sheet',1);
        waitbar(0.3,d,'Espere,guardando datos');
        writetable(Data2,var.file_e,'Sheet',2);
        waitbar(0.7,d,'Espere,guardando datos');
        writetable(Data3,var.file_e,'Sheet',3, 'WriteVariableNames', 0);
        
        waitbar(1,d,'Listo');
        pause(1)
        close(d)
    end
[~,nf]=size(var.data_mcc);
[~,nf2]=size(var.data_ni);
nombre={'Laser 1','Laser 2','Laser 3','Laser 4','Laser 5','Laser 6','Laser 7','Laser 8',...
    'Laser 9','Laser 10','Laser 11','Laser 12','Laser 13','Laser 14'};

nombre2={'Celda 1','Celda 2','Celda 3','Celda 4','Celda 5','Geofono 1','Geofono 2','Geofono 3'};
d=figure('color','white','units','normalize');
set(gcf,'position',[0.1    0.1   0.8    0.8])

for i=1:nf
    plot(var.tiempo_mcc, var.data_mcc(:,i))
    title(nombre{i})
    xlabel('Time (s)')
    ylabel('Voltage (V)')
    print(d,[path_e,'\',nombre{i},'.png'],'-dpng','-r300');
end

for i=1:nf2-1
    plot(var.tiempo_ni, var.data_ni(:,i))
    title(nombre2{i})
    xlabel('Time (s)')
    ylabel('Voltage (V)')
    print(d,[path_e,'\',nombre2{i},'.png'],'-dpng','-r300');
end

close(d)
d = waitbar(1,'Listo');
pause(1)
close(d)     
    
     
end

function r = getGlobalx
global datos
r = datos;

function getData(src,event)
global datos 
    datos=[datos;event.Data];

