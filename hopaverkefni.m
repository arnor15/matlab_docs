close all
clear all
clc

%% 1. L�ti� Matlab finna sj�lfvirkt allar gagnarkskr�rnar og lesa ��r sj�lfvirkt inn 

dirData = dir('SUB*.xlsx');

for i = 1 : length(dirData)
    % S�ki nafn � skr�
    fileName = (dirData(i).name);
    
    % S�ki nafn fyrir hvert variable
    variableName = strsplit((dirData(i).name),'.');
    variableName = variableName{1};
    variableName = convertCharsToStrings(variableName);
    
    % Athuga hvort skr� s� me� opin e�a loku� augu
    if isempty(strfind(variableName,'open')) == 0
        VariableList{i}.type = 'open';
    else
        VariableList{i}.type = 'closed';
    end
    VariableList{i}.type = convertCharsToStrings(VariableList{i}.type);
    
    % Set hverja skr� � variable merkt s�r.
    VariableList{i}.name = variableName;
    VariableList{i}.data = xlsread(fileName);
end

%% 2. Mi�a� vi� s�fnunart��ni upp � 50Hz, hva� tekur ein m�ling langan t�ma?

% 50Hz = 20ms (millisecond)

%% 3. Skrifi� fall sem telur fj�lda stimulusa og reiknar �t me�alt�malengd �eirra. Skrifi� �t ni�urst��urnar � command window

stimuli = xlsread('Stimuli.xlsx');  % S�ki allar stimuli m�lingar
calculateStimuli(stimuli) 

%% 4. Teikni� upp gr�fin fyrir einstaklingana eins og s�st er � mynd 2 og l�ti� Matlab vista myndirnar sj�lfkrafa � undirm�ppunni "myndir"

% Fyrst a� athuga hvort mappan "Myndir" s� til, 
% ef ekki, �� b�a hana til
if exist('Myndir', 'dir') == 7

else
    mkdir Myndir
end

% S�ki stimuli skr�nna sem ver�ur notu� � �llum plotum
stimuli = xlsread('Stimuli.xlsx');
xStimuli = stimuli(:,1);
yStimuli = stimuli(:, 2);

% �egar gildin � inntaksbreytu eru 59, er �eim breytt � 1 og �a� ���ir a� �rvun s� �.
% Ef gildi� er 20, er �v� breytt � 0 og �a� ���ir a� �rvun s� af.
% Annars skilar falli� villu � �v� staki sem villan fundin.
for i = 1 : length(yStimuli)
    if yStimuli(i)==20
    yStimuli(i)=0;
    elseif yStimuli(i)==59
    yStimuli(i)=1;
    end
end

% Skilgreinir plot titla
TitleOpen = ["Opin augu: Medial/Lateral v�gi", "Opin augu: Anterior/Posterior v�gi"]
TitleClosed = ["Loku� augu: Medial/Lateral v�gi", "Loku� augu: Anterior/Posterior v�gi"]

% Plottar upp eina mynd me� 3 subplottum og vistar fyrir hvert gagnasett
for i = 1 : length(VariableList)
     
    % B�r til n�ja mynd, sem birtist ekki � skj�num
    % �v� vi� �tlum bara a� vista hana.
    newFigure = figure;
    
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
    
    % Athugar hvort eigi a� nota� titil fyrir
    % opin e�a loku� augu
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
    
    % B� til filepath til a� vista figure
    basefile = convertCharsToStrings(pwd);
    filename = '/Myndir/' + VariableList{i}.name + '.fig';
    filePath = pwd + filename;
    
    % Vistar mynd undir "Myndir"
    saveas(newFigure, filePath);
end

%% 5.Teikni� upp muninn � sveigjunni � pl�nunum tveimur eins og s�nt er � mynd 3 
















