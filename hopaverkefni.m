close all
clear all
clc

%% 1. Látið Matlab finna sjálfvirkt allar gagnarkskrárnar og lesa þær sjálfvirkt inn 

% Sæki stimuli skránna sem verður notuð í öllum plotum
stimuli = xlsread('Stimuli.xlsx');

% Sæki nöfnin á öllum SUB skrám
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

stimuli = xlsread('Stimuli.xlsx');  % Sæki allar stimuli mælingar
calculateStimuli(stimuli)           


%% 4. Teiknið upp gröfin fyrir einstaklingana eins og sést er á mynd 2 og látið Matlab vista myndirnar sjálfkrafa í undirmöppunni "myndir"

% Fyrst að athuga hvort mappan "Myndir" sé til, 
% ef ekki, þá búa hana til
if exist('Myndir', 'dir') == 7

else
    mkdir Myndir
end

xStimuli = stimuli(:,1);
yStimuli = stimuli(:, 2);

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

% Skilgreinir plot titla
TitleOpen = ["Opin augu"];
TitleClosed = ["Lokuð augu"];

%for i = 1 : length(VariableList)
for i = 1 : 2
    Lateral_xAs = VariableList{i}.data(:,2);
    Anteroposterior_yAs = VariableList{i}.data(:, 3);

    % Athugar hvort eigi að notað titil fyrir
    % opin eða lokuð augu
    if VariableList{i}.type == 'open'
        Title = TitleOpen;
    else
        Title = TitleClosed;
    end
    
    newFigure = figure;
    hold on
    title(Title);
    xlabel('Anterior/posterior [Nm]');
    ylabel('Medial/Lateral [Nm]');
    scatter(Lateral_xAs,Anteroposterior_yAs, '.')
    axis([-20 20 -40 40]);
    hold off;

end
    

%% 6. Hvernig breytist staðan milli Q1, Q2, Q3 og Q4. Tekst fólki að læra inn á það hvernig bregaðst skuli við örvunum?

for i = 1 : length(VariableList)

    Lateral_xAs = VariableList{i}.data(:,2);
    Anteroposterior_yAs = VariableList{i}.data(:, 3);
    
    medaltalLateralQ1(i) = mean(Lateral_xAs(1501:5250));
    medaltalLateralQ2(i) = mean(Lateral_xAs(5251:9000));
    medaltalLateralQ3(i) = mean(Lateral_xAs(9001:12750));
    medaltalLateralQ4(i) = mean(Lateral_xAs(12751:16500));
    medaltalAnteroposteriorQ1(i) = mean(Anteroposterior_yAs(1501:5250));
    medaltalAnteroposteriorQ2(i) = mean(Anteroposterior_yAs(5251:9000));
    medaltalAnteroposteriorQ3(i) = mean(Anteroposterior_yAs(9001:12750));
    medaltalAnteroposteriorQ4(i) = mean(Anteroposterior_yAs(12751:16500));

    stdLateralQ1(i) = std(Lateral_xAs(1501:5250));
    stdLateralQ2(i) = std(Lateral_xAs(5251:9000));
    stdLateralQ3(i) = std(Lateral_xAs(9001:12750));
    stdLateralQ4(i) = std(Lateral_xAs(12751:16500));
    stdAnteroposteriorQ1(i) = std(Anteroposterior_yAs(1501:5250));
    stdAnteroposteriorQ2(i) = std(Anteroposterior_yAs(5251:9000));
    stdAnteroposteriorQ3(i) = std(Anteroposterior_yAs(9001:12750));
    stdAnteroposteriorQ4(i) = std(Anteroposterior_yAs(12751:16500));
    
end

figure
hold on
bar(1, mean(stdLateralQ1))
bar(2, mean(stdAnteroposteriorQ1))
bar(3, mean(stdLateralQ2))
bar(4, mean(stdAnteroposteriorQ2))
bar(5, mean(stdLateralQ3))
bar(6, mean(stdAnteroposteriorQ3))
bar(7, mean(stdLateralQ4))
bar(8, mean(stdAnteroposteriorQ4))
hold off

figure
for i = 1 : length(VariableList)
   hold on
   scatter(y1, medaltalAnteroposteriorQ1);
   scatter(y2, medaltalAnteroposteriorQ2);
   scatter(y3, medaltalAnteroposteriorQ3);
   scatter(y4, medaltalAnteroposteriorQ4);
end
hold off

figure
for i = 1 : length(VariableList)
   hold on
   scatter(y1, medaltalLateralQ1);
   scatter(y2, medaltalLateralQ2);
   scatter(y3, medaltalLateralQ3);
   scatter(y4, medaltalLateralQ4);
end
hold off



y1 = (1:66);
for i = 1 : length(y1)
    y1(i) = 1;
end
y2 = (1:66);
for i = 1 : length(y2)
    y2(i) = 2;
end
y3 = (1:66);
for i = 1 : length(y3)
    y3(i) = 3;
end
y4 = (1:66);
for i = 1 : length(y4)
    y4(i) = 4;
end
    

    
%% 7. Gerið greiningu á muninum milli þess að hafa opin augu vs að hafa lokuð augu. 

%% 8. Hvaða einstaklingur stóð sig best í prófinu miðað við ykkar niðurstöður
