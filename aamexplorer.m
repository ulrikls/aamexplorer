function varargout = aamexplorer(varargin)
% AAMEXPLORER MATLAB code for aamexplorer.fig
%      AAMEXPLORER, by itself, creates a new AAMEXPLORER or raises the existing
%      singleton*.
%
%      H = AAMEXPLORER returns the handle to a new AAMEXPLORER or the handle to
%      the existing singleton*.
%
%      AAMEXPLORER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AAMEXPLORER.M with the given input arguments.
%
%      AAMEXPLORER('Property','Value',...) creates a new AAMEXPLORER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before aamexplorer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to aamexplorer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help aamexplorer

% Last Modified by GUIDE v2.5 26-Nov-2011 22:09:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
  'gui_Singleton',  gui_Singleton, ...
  'gui_OpeningFcn', @aamexplorer_OpeningFcn, ...
  'gui_OutputFcn',  @aamexplorer_OutputFcn, ...
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


% --- Executes just before aamexplorer is made visible.
function aamexplorer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to aamexplorer (see VARARGIN)

% Variables: mshape, mgray, Qshape, Qgray, sigma2c, dimensions, [c]
if size(varargin,2) < 6 && isstruct(varargin{1})
  handles.model = varargin{1};
  if size(varargin,2) > 1
    handles.model.c = varargin{2};
    set(handles.buttoninitial, 'Enable', 'on');
  end
elseif size(varargin,2) >= 6
  handles.model.mshape = varargin{1};
  handles.model.mgray = varargin{2};
  handles.model.Qshape = varargin{3};
  handles.model.Qgray = varargin{4};
  handles.model.sigma2c = varargin{5};
  handles.model.dimensions = varargin{6};
  if size(varargin,2) > 6
    handles.model.c = varargin{7};
    set(handles.buttoninitial, 'Enable', 'on');
  end
else
  error('AAMexplorer:nomodel', 'No active appearance model given.');
end

% GUI state
handles.state.cursor = fix(handles.model.dimensions ./ 2);

% Choose default command line output for aamexplorer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes aamexplorer wait for user response (see UIRESUME)
% uiwait(handles.main);
param_Callback(hObject, eventdata, handles)


% --- Outputs from this function are returned to the command line.
function varargout = aamexplorer_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when main is resized.
function main_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.axes3d);

pos = get(hObject, 'Position');
width = pos(3);
height = pos(4);

pw = 180;
margin = [16 8 8 8];
panelw = fix((width-pw)/2);
panelh = fix(height/2);

set(handles.panelparam, 'Position', [1, 1, pw, height]);
set(handles.panelxy, 'Position', [pw,        panelh, panelw, panelh]);
set(handles.panelyz, 'Position', [pw+panelw, panelh, panelw, panelh]);
set(handles.panel3d, 'Position', [pw,        1,      panelw, panelh]);
set(handles.panelxz, 'Position', [pw+panelw, 1,      panelw, panelh]);
set(handles.axesxy, 'Position', [margin(4), margin(3), panelw-margin(2)-margin(4), panelh-margin(1)-margin(3)]);
set(handles.axesyz, 'Position', [margin(4), margin(3), panelw-margin(2)-margin(4), panelh-margin(1)-margin(3)]);
set(handles.axes3d, 'Position', [margin(4), margin(3), panelw-margin(2)-margin(4), panelh-margin(1)-margin(3)]);
set(handles.axesxz, 'Position', [margin(4), margin(3), panelw-margin(2)-margin(4), panelh-margin(1)-margin(3)]);
set(handles.buttonreset,   'Position', [8,  height-37, 78, 21]);
set(handles.buttoninitial, 'Position', [94, height-37, 78, 21]);
set(handles.param1, 'Position', [8, height-60 , 164, 15]);
set(handles.param2, 'Position', [8, height-83 , 164, 15]);
set(handles.param3, 'Position', [8, height-106, 164, 15]);
set(handles.param4, 'Position', [8, height-129, 164, 15]);
set(handles.param5, 'Position', [8, height-152, 164, 15]);


% --- Executes on parameter slider movement.
function param_Callback(hObject, eventdata, handles)
% hObject    handle to paramX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

c = zeros(length(handles.model.sigma2c),1);
c(1) = get(handles.param1, 'Value');
c(2) = get(handles.param2, 'Value');
c(3) = get(handles.param3, 'Value');
c(4) = get(handles.param4, 'Value');
c(5) = get(handles.param5, 'Value');
c = c .* 2 .* sqrt(handles.model.sigma2c);

handles.state.shape = reshape(handles.model.mshape + handles.model.Qshape * c, ...
  handles.model.dimensions);
handles.state.gray = reshape(handles.model.mgray + handles.model.Qgray * c, ...
  handles.model.dimensions);

guidata(hObject, handles);

plotplanes(handles);

% 3-D
plot3d(handles.axes3d, handles.state.shape);


function plotplanes(handles)

% X-Y
slice = handles.state.cursor(3);
plotplane(handles.axesxy, ...
  rot90(squeeze(handles.state.shape(:,:,slice))), ...
  rot90(squeeze(handles.state.gray(:,:,slice))), ...
  [handles.state.cursor(1), handles.state.cursor(2)]);

% Y-Z
slice = handles.state.cursor(1);
plotplane(handles.axesyz, ...
  rot90(squeeze(handles.state.shape(slice,:,:))',2), ...
  rot90(squeeze(handles.state.gray(slice,:,:))',2), ...
  [handles.state.cursor(2), handles.state.cursor(3)]);

% X-Z
slice = handles.state.cursor(2);
plotplane(handles.axesxz, ...
  rot90(squeeze(handles.state.shape(:,slice,:))), ...
  rot90(squeeze(handles.state.gray(:,slice,:))), ...
  [handles.state.cursor(1), handles.state.cursor(3)]);



function plotplane(ax, shape, gray, cursor)
axes(ax);
cla;
imshow(gray, [-450 1050]);
hold on;
contour(shape, [0 0], 'g');
line([cursor(1) cursor(1)], get(ax, 'YLim'), 'Color', [.4 .8 1], 'LineStyle', ':');
line(get(ax, 'XLim'), [cursor(2) cursor(2)], 'Color', [.4 .8 1], 'LineStyle', ':');
hold off;


function plot3d(ax, shape)
axes(ax)
[az,el] = view(ax);
cla;
fv = isosurface(shape, 0);
patch(fv, 'FaceColor', [0 1 0], 'EdgeColor', 'none');
axis off equal tight vis3d;
%rotate3d(ax,'on');
lh = camlight('left');
set(lh, 'Color', [.5 .5 .5]);
lh = camlight('right');
set(lh, 'Color', [.5 .5 .5]);
lighting gouraud;
if az==0 && el==90
  view(ax,3);
else
  view(ax,az,el);
end


% --- Executes on button press in buttonreset.
function buttonreset_Callback(hObject, eventdata, handles)
% hObject    handle to buttonreset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.param1, 'Value', 0);
set(handles.param2, 'Value', 0);
set(handles.param3, 'Value', 0);
set(handles.param4, 'Value', 0);
set(handles.param5, 'Value', 0);
param_Callback(hObject, eventdata, handles);


% --- Executes on button press in buttoninitial.
function buttoninitial_Callback(hObject, eventdata, handles)
% hObject    handle to buttoninitial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

c = handles.model.c ./ sqrt(handles.model.sigma2c) ./ (-2);
set(handles.param1, 'Value', c(1));
set(handles.param2, 'Value', c(2));
set(handles.param3, 'Value', c(3));
set(handles.param4, 'Value', c(4));
set(handles.param5, 'Value', c(5));
param_Callback(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function param1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function param2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function param3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function param4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function param5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on scroll wheel click while the figure is in focus.
function main_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to main (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)

pointer = get(hObject, 'CurrentPoint');

xypanelpos = get(handles.panelxy, 'Position');
xypos = get(handles.axesxy, 'Position');
xypos(1:2) = xypanelpos(1:2) + xypos(1:2);

yzpanelpos = get(handles.panelyz, 'Position');
yzpos = get(handles.axesyz, 'Position');
yzpos(1:2) = yzpanelpos(1:2) + yzpos(1:2);

xzpanelpos = get(handles.panelxz, 'Position');
xzpos = get(handles.axesxz, 'Position');
xzpos(1:2) = xzpanelpos(1:2) + xzpos(1:2);

% Within X-Z figure
if pointer(1) > xypos(1) && pointer(1) < xypos(1) + xypos(3) && ...
    pointer(2) > xypos(2) && pointer(2) < xypos(2) + xypos(4)
  z = handles.state.cursor(3) + eventdata.VerticalScrollCount;
  handles.state.cursor(3) = max(min(z, handles.model.dimensions(3)), 1);
  % Within Y-Z figure
elseif pointer(1) > yzpos(1) && pointer(1) < yzpos(1) + yzpos(3) && ...
    pointer(2) > yzpos(2) && pointer(2) < yzpos(2) + yzpos(4)
  x = handles.state.cursor(1) + eventdata.VerticalScrollCount;
  handles.state.cursor(1) = max(min(x, handles.model.dimensions(1)), 1);
  % Within X-Z figure
elseif pointer(1) > xzpos(1) && pointer(1) < xzpos(1) + xzpos(3) && ...
    pointer(2) > xzpos(2) && pointer(2) < xzpos(2) + xzpos(4)
  y = handles.state.cursor(2) + eventdata.VerticalScrollCount;
  handles.state.cursor(2) = max(min(y, handles.model.dimensions(2)), 1);
end

guidata(hObject, handles);

plotplanes(handles);




