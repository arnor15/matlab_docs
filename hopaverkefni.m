close all
clear all
clc

%% 1. Látið Matlab finna sjálfvirkt allar gagnarkskrárnar og lesa þær sjálfvirkt inn 

dirData = dir('SUB*.xlsx');

% Bara finna open / closed
% dirData = dir('SUB*open*.xlsx');
% dirData.name

for i = 1 : length(dirData)
    % Sæki nafn á skrá
    fileName = (dirData(i).name);
    
    % Sæki nafn fyrir hvert variable
    variableName = strsplit((dirData(i).name),'.');
    variableName = variableName{1};
    variableName = convertCharsToStrings(variableName)
    
    % Athuga hvort skrá sé með opin eða lokuð augu
    if isempty(strfind(variableName,'open')) == 0
        VariableList{i}.type = 'open';
    else
        VariableList{i}.type = 'closed';
    end
    VariableList{i}.type = convertCharsToStrings(VariableList{i}.type)
    
    % Set hverja skrá í variable merkt sér.
    VariableList{i}.name = variableName;
    VariableList{i}.data = xlsread(fileName);
end

%% 2. Miðað við söfnunartíðni upp á 50Hz, hvað tekur ein mæling langan tíma?

% 50Hz = 20ms (millisecond)

%% 3. Skrifið fall sem telur fjölda stimulusa og reiknar út meðaltímalengd þeirra. Skrifið út niðurstöðurnar í command window

    

%% 4. Teiknið upp gröfin fyrir einstaklingana eins og sést er á mynd 2 og látið Matlab vista myndirnar sjálfkrafa í undirmöppunni "myndir"

% Fyrst að athuga hvort mappan "Myndir" sé til, 
% ef ekki, þá búa hana til
if exist('Myndir', 'dir') == 7

else
    mkdir Myndir
end

% Sæki stimuli skránna sem verður notuð í öllum plotum
Stimuli = xlsread('Stimuli.xlsx');
xStimuli = Stimuli(:,1);
yStimuli = Stimuli(:, 2);
yStimuli = changeStimuliFormat(yStimuli);

% Þegar gildin í inntaksbreytu eru 59, er þeim breytt í 1 og það þýðir að örvun sé á.
% Ef gildið er 20, er því breytt í 0 og það þýðir að örvun sé af.
% Annars skilar fallið villu í því staki sem villan fundin.
for i = 1 : length(yStimuli)
    if yStimuli(i)==20
    yStimuli(i)=0;
    elseif yStimuli(i)==59
    yStimuli(i)=1;
    end
end

% Skilgreinir plot titla
TitleOpen = ["Opin augu: Medial/Lateral vægi", "Opin augu: Anterior/Posterior vægi"]
TitleClosed = ["Lokuð augu: Medial/Lateral vægi", "Lokuð augu: Anterior/Posterior vægi"]

% Plottar upp eina mynd með 3 subplottum og vistar fyrir hvert gagnasett
for i = 1 : length(VariableList)
     
    % Býr til nýja mynd, sem birtist ekki á skjánum
    % því við ætlum bara að vista hana.
    newFigure = figure('visible','off');
    
    % --- plot 1 ---
    
    subplot(3,1,1);
    hold on
    title('Stimuli');
    xlabel('Time[s]');
    plot(xStimuli(1:1501),yStimuli(1:1501),'m');
    plot(xStimuli(1501:5250),yStimuli(1501:5250),'r');
    plot(xStimuli(5251:9000),yStimuli(5251:9000),'g');
    plot(xStimuli(9001:12750),yStimuli(9001:12750),'b');
    plot(xStimuli(12751:16500),yStimuli(12751:16500),'k');
    axis([0 350 -1 2]);
    set(gca, 'yticklabel', []);
    hold off;
    
    % Athugar hvort eigi að notað titil fyrir
    % opin eða lokuð augu
    if VariableList{i}.type == 'open'
        Title = TitleOpen;
    else
        Title = TitleClosed;
    end
    
    % --- plot 2 ---
    
    xAs = VariableList{i}.data(:,1);
    yAs = VariableList{i}.data(:, 2);

    subplot(3,1,2);
    hold on;
    title(Title(1));
    xlabel('Time[s]');
    ylabel('Torque [Nm]');
    plot(xAs(1:1501),yAs(1:1501),'m');
    plot(xAs(1501:5250),yAs(1501:5250),'r');
    plot(xAs(5251:9000),yAs(5251:9000),'g');
    plot(xAs(9001:12750),yAs(9001:12750),'b');
    plot(xAs(12751:16500),yAs(12751:16500),'k');
    axis([0 350 -40 40]);
    set(gca, 'yticklabel', []);
    hold off;
    
    % --- plot 3 ---
    
    yAs = VariableList{i}.data(:, 3);    
    
    subplot(3,1,3);
    hold on;
    title(Title(2));
    xlabel('Time[s]');
    ylabel('Torque [Nm]');
    plot(xAs(1:1501),yAs(1:1501),'m');
    plot(xAs(1501:5250),yAs(1501:5250),'r');
    plot(xAs(5251:9000),yAs(5251:9000),'g');
    plot(xAs(9001:12750),yAs(9001:12750),'b');
    plot(xAs(12751:16500),yAs(12751:16500),'k');
    axis([0 350 -40 40]);
    set(gca, 'yticklabel', []);
    hold off;
    
    % Bý til filepath til að vista figure
    basefile = convertCharsToStrings(pwd);
    filename = '/Myndir/' + VariableList{i}.name + '.fig';
    filePath = pwd + filename;
    
    % Vistar mynd undir "Myndir"
    saveas(newFigure, filePath);
end

%% 5.Teiknið upp muninn á sveigjunni í plönunum tveimur eins og sýnt er á mynd 3 
















