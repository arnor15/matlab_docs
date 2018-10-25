close all
clear all
clc

%% 1. L�ti� Matlab finna sj�lfvirkt allar gagnarkskr�rnar og lesa ��r sj�lfvirkt inn 

% S�ki stimuli skr�nna sem ver�ur notu� � �llum plotum
stimuli = xlsread('Stimuli.xlsx');

% S�ki n�fnin � �llum SUB skr�m
dirData = dir('SUB*.xlsx');

% Bara finna open / closed
% dirData = dir('SUB*open*.xlsx');
% dirData.name

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

% ?

%% 3. Skrifi� fall sem telur fj�lda stimulusa og reiknar �t me�alt�malengd �eirra. Skrifi� �t ni�urst��urnar � command window

calculateStimuli(stimuli)           


%% 4. Teikni� upp gr�fin fyrir einstaklingana eins og s�st er � mynd 2 og l�ti� Matlab vista myndirnar sj�lfkrafa � undirm�ppunni "myndir"

% Fyrst a� athuga hvort mappan "Myndir" s� til, 
% ef ekki, �� b�a hana til
if exist('Myndir', 'dir') == 7

else
    mkdir Myndir
end

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
TitleOpen = ["Opin augu: Medial/Lateral v�gi", "Opin augu: Anterior/Posterior v�gi"];
TitleClosed = ["Loku� augu: Medial/Lateral v�gi", "Loku� augu: Anterior/Posterior v�gi"];

% Plottar upp eina mynd me� 3 subplottum og vistar fyrir hvert gagnasett
for i = 1 : length(VariableList)
     
    % B�r til n�ja mynd, sem birtist ekki � skj�num
    % �v� vi� �tlum bara a� vista hana.
    newFigure = figure('visible', 'off');
    
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
    filename = '/Myndir/' + VariableList{i}.name + '.png';
    filePath = pwd + filename;
    
    % Vistar mynd undir "Myndir"
    saveas(newFigure, filePath);
    close(newFigure);
end

%% 5.Teikni� upp muninn � sveigjunni � pl�nunum tveimur eins og s�nt er � mynd 3 

% Skilgreinir plot titla
TitleOpen = "Opin augu";
TitleClosed = "Loku� augu";

for i = 1 : length(VariableList)

    Lateral_xAs = VariableList{i}.data(:,2);
    Anteroposterior_yAs = VariableList{i}.data(:, 3);

    % Athugar hvort eigi a� nota� titil fyrir
    % opin e�a loku� augu
    if VariableList{i}.type == 'open'
        Title = TitleOpen;
    else
        Title = TitleClosed;
    end
    
    newFigure = figure('visible', 'off');
    hold on
    title(Title);
    xlabel('Anterior/posterior [Nm]');
    ylabel('Medial/Lateral [Nm]');
    scatter(Lateral_xAs,Anteroposterior_yAs, '.')
    axis([-25 25 -50 50]);
    
    % B� til filepath til a� vista myndina
    basefile = convertCharsToStrings(pwd);
    filename = '/Myndir/' + VariableList{i}.name + '_sveigja' + '.png';
    filePath = pwd + filename;
    
    % Vista mynd
    saveas(newFigure, filePath);
    
    hold off;
    close(newFigure);

end





%% 6. Hvernig breytist sta�an milli Q1, Q2, Q3 og Q4. Tekst f�lki a� l�ra inn � �a� hvernig brega�st skuli vi� �rvunum?

for i = 1 : length(VariableList)

    Lateral_xAs = VariableList{i}.data(:,2);
    Anteroposterior_yAs = VariableList{i}.data(:, 3);
    
    %medaltalLateralQS(i) = mean(Lateral_xAs(1:1500));
    medaltalLateralQ1(i) = mean(Lateral_xAs(1501:5250));
    medaltalLateralQ2(i) = mean(Lateral_xAs(5251:9000));
    medaltalLateralQ3(i) = mean(Lateral_xAs(9001:12750));
    medaltalLateralQ4(i) = mean(Lateral_xAs(12751:16500));
    %medaltalAnteroposteriorQS(i) = mean(Anteroposterior_yAs(1:1500));
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

% Me�altal af me�alt�lum
totalMedaltalLateralQ1 = mean(medaltalLateralQ1);
totalMedaltalLateralQ2 = mean(medaltalLateralQ2);
totalMedaltalLateralQ3 = mean(medaltalLateralQ3);
totalMedaltalLateralQ4 = mean(medaltalLateralQ4);
totalMedaltalAnteroposteriorQ1 = mean(medaltalAnteroposteriorQ3);
totalMedaltalAnteroposteriorQ2 = mean(medaltalAnteroposteriorQ3);
totalMedaltalAnteroposteriorQ3 = mean(medaltalAnteroposteriorQ3);
totalMedaltalAnteroposteriorQ4 = mean(medaltalAnteroposteriorQ3);

% Me�altal af sta�alfr�vikum
totalStdLateralQ1 = mean(stdLateralQ1);
totalStdLateralQ2 = mean(stdLateralQ2);
totalStdLateralQ3 = mean(stdLateralQ3);
totalStdLateralQ4 = mean(stdLateralQ4);
totalStdAnteroposteriorQ1 = mean(stdAnteroposteriorQ1);
totalStdAnteroposteriorQ2 = mean(stdAnteroposteriorQ2);
totalStdAnteroposteriorQ3 = mean(stdAnteroposteriorQ3);
totalStdAnteroposteriorQ4 = mean(stdAnteroposteriorQ4);

% Teikna mynd af dreifingu
figure;
hold on
subplot(2,4,1);
histfit(medaltalLateralQ1)
axis([-5 5 0 30]);
subplot(2,4,2);
histfit(medaltalLateralQ2)
axis([-5 5 0 30]);
subplot(2,4,3);
histfit(medaltalLateralQ3)
axis([-5 5 0 30]);
subplot(2,4,4);
histfit(medaltalLateralQ4)
axis([-5 5 0 30]);
subplot(2,4,5);
histfit(medaltalAnteroposteriorQ1)
axis([-20 20 0 30]);
subplot(2,4,6);
histfit(medaltalAnteroposteriorQ2)
axis([-20 20 0 30]);
subplot(2,4,7);
histfit(medaltalAnteroposteriorQ3)
axis([-20 20 0 30]);
subplot(2,4,8);
histfit(medaltalAnteroposteriorQ4)
axis([-20 20 0 30]);

% Reikna �t hvort �a� s� markt�kur munur � milli t�mabila
testLateralQ1vsQ2 = ttest2(medaltalLateralQ1, medaltalLateralQ2)
testLateralQ2vsQ3 = ttest2(medaltalLateralQ2, medaltalLateralQ3)
testLateralQ3vsQ4 = ttest2(medaltalLateralQ3, medaltalLateralQ4)

testAnteroposteriorQ1vsQ2 = ttest2(medaltalAnteroposteriorQ1, medaltalAnteroposteriorQ2)
testAnteroposteriorQ2vsQ3 = ttest2(medaltalAnteroposteriorQ2, medaltalAnteroposteriorQ3)
testAnteroposteriorQ3vsQ4 = ttest2(medaltalAnteroposteriorQ3, medaltalAnteroposteriorQ4)

 
%% 7. Geri� greiningu � muninum milli �ess a� hafa opin augu vs a� hafa loku� augu. 

%% 8. Hva�a einstaklingur st�� sig best � pr�finu mi�a� vi� ykkar ni�urst��ur
