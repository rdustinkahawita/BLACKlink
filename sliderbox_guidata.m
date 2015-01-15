function varargout = sliderbox_guidata(varargin)
%SLIDERBOX_GUIDATA M-file for sliderbox_guidata.fig
%      SLIDERBOX_GUIDATA, by itself, creates a new SLIDERBOX_GUIDATA or raises the existing
%      singleton*.
%
%      H = SLIDERBOX_GUIDATA returns the handle to a new SLIDERBOX_GUIDATA or the handle to
%      the existing singleton*.
%
%      SLIDERBOX_GUIDATA('Property','Value',...) creates a new SLIDERBOX_GUIDATA using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to sliderbox_guidata_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SLIDERBOX_GUIDATA('CALLBACK') and SLIDERBOX_GUIDATA('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SLIDERBOX_GUIDATA.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
%      This GUI uses the Handles Structure and GUIDATA to communicate 
%      between a slider and the edit text box as well as to keep a
%      count of the number of errors the user makes in the edit box.
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sliderbox_guidata

% Last Modified by GUIDE v2.5 26-Nov-2008 13:59:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sliderbox_guidata_OpeningFcn, ...
                   'gui_OutputFcn',  @sliderbox_guidata_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before sliderbox_guidata is made visible.
function sliderbox_guidata_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for sliderbox_guidata
handles.output = hObject;
% INITALIZE ERROR COUNT AND USE GUIDATA TO UPDATE THE HANDLES STRUCTURE.
handles.number_errors = 0;

% Update handles structure
guidata(hObject,handles);

% UIWAIT makes sliderbox_guidata wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sliderbox_guidata_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

set(handles.edittext1,'String',...
   num2str(get(handles.slider1,'Value')));

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function edittext1_Callback(hObject, eventdata, handles)
% hObject    handle to edittext1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edittext1 as text
%        str2double(get(hObject,'String')) returns contents of edittext1 as a double

val = str2double(get(hObject,'String'));
% Determine whether val is a number between 0 and 1.
if isnumeric(val) && length(val)==1 && ...
   val >= get(handles.slider1,'Min') && ...
   val <= get(handles.slider1,'Max')
   set(handles.slider1,'Value',val);
else
% Increment the error count, and display it.
   handles.number_errors = handles.number_errors+1;
   guidata(hObject,handles); % Store the changes.
   set(hObject,'String',...
   ['You have entered an invalid entry ',...
    num2str(handles.number_errors),' times.']);
   % Restore focus to the edit text box after error
   uicontrol(hObject)
end


% --- Executes during object creation, after setting all properties.
function edittext1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edittext1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


