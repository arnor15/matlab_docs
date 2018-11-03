close all
clear all
clc

%% 1. Látið Matlab finna sjálfvirkt allar gagnarkskrárnar og lesa þær sjálfvirkt inn 
fprintf('1. Látið Matlab finna sjálfvirkt allar gagnarkskrárnar og lesa þær sjálfvirkt inn \n') 

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
    variableName = convertCharsToStrings(variableName);
    
    fprintf('Saeki gogn ur %s', variableName)
    
    % Athuga hvort skrá sé með opin eða lokuð augu
    if isempty(strfind(variableName,'open')) == 0
        VariableList{i}.type = 'open';
    else
        VariableList{i}.type = 'closed';
    end
    VariableList{i}.type = convertCharsToStrings(VariableList{i}.type);
    
    % Set hverja skrá í variable merkt sér.
    VariableList{i}.name = variableName;
    VariableList{i}.data = xlsread(fileName);
end

%% 2. Miðað við söfnunartíðni upp á 50Hz, hvað tekur ein mæling langan tíma?
fprintf('2. Miðað við söfnunartíðni upp á 50Hz, hvað tekur ein mæling langan tíma? \n') 

% ?

%% 3. Skrifið fall sem telur fjölda stimulusa og reiknar út meðaltímalengd þeirra. Skrifið út niðurstöðurnar í command window
fprintf('3. Skrifið fall sem telur fjölda stimulusa og reiknar út meðaltímalengd þeirra. Skrifið út niðurstöðurnar í command window \n')

calculateStimuli(stimuli)        


%% 4. Teiknið upp gröfin fyrir einstaklingana eins og sést er á mynd 2 og látið Matlab vista myndirnar sjálfkrafa í undirmöppunni "myndir"
fprintf('4. Teiknið upp gröfin fyrir einstaklingana eins og sést er á mynd 2 og látið Matlab vista myndirnar sjálfkrafa í undirmöppunni - myndir \n')

% Fyrst að athuga hvort mappan "Myndir" sé til, 
% ef ekki, þá búa hana til
if exist('Myndir', 'dir') == 7
    fprintf('Mappan myndir er þegar til...\n')
else
    fprintf('Mappan myndir er ekki til, by hana til...\n')
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
TitleOpen = ["Opin augu: Medial/Lateral vægi", "Opin augu: Anterior/Posterior vægi"];
TitleClosed = ["Lokuð augu: Medial/Lateral vægi", "Lokuð augu: Anterior/Posterior vægi"];

% Plottar upp eina mynd með 3 subplottum og vistar fyrir hvert gagnasett
for i = 1 : length(VariableList)
    
    fprintf('Bý til mynd nr %d ...\n', i)   
    % Býr til nýja mynd, sem birtist ekki á skjánum
    % því við ætlum bara að vista hana.
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
    filename = '/Myndir/' + VariableList{i}.name + '.png';
    filePath = pwd + filename;
    
    % Vistar mynd undir "Myndir"
    saveas(newFigure, filePath);
    close(newFigure);
end

%% 5.Teiknið upp muninn á sveigjunni í plönunum tveimur eins og sýnt er á mynd 3 
fprintf('5.Teiknið upp muninn á sveigjunni í plönunum tveimur eins og sýnt er á mynd 3 \n')

% Skilgreinir plot titla
TitleOpen = "Opin augu";
TitleClosed = "Lokuð augu";

for i = 1 : length(VariableList)
    fprintf('Bý til sveigju mynd nr %d ...\n', i) 
    
    Lateral_xAs = VariableList{i}.data(:,2);
    AnteriorPosterior_yAs = VariableList{i}.data(:, 3);

    % Athugar hvort eigi að notað titil fyrir
    % opin eða lokuð augu
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
    scatter(Lateral_xAs,AnteriorPosterior_yAs, '.')
    axis([-25 25 -50 50]);
    
    % Bý til filepath til að vista myndina
    basefile = convertCharsToStrings(pwd);
    filename = '/Myndir/' + VariableList{i}.name + '_sveigja' + '.png';
    filePath = pwd + filename;
    
    % Vista mynd
    saveas(newFigure, filePath);
    
    hold off;
    close(newFigure);

end


%% 6. Hvernig breytist staðan milli Q1, Q2, Q3 og Q4. Tekst fólki að læra inn á það hvernig bregaðst skuli við örvunum?
fprintf('6. Hvernig breytist staðan milli Q1, Q2, Q3 og Q4. Tekst fólki að læra inn á það hvernig bregaðst skuli við örvunum? \n')

%  Lykkja sem leggur saman öll stök allra þáttakenda(SUBJECTS) og 
%  finnur meðaltöl þeirra. T.d. þá er byrjað á því að taka stak nr
%  1 fyrir bæði lateral og Anteroposterior fyrir alla þáttakendur 
%  og það er lagt saman, fundið meðaltal af þeim og þau svo geymd
%  í breytunum meanLateral og meanAnteroposterior. 
%  Þannig er fundið eitt meðaltal fyrir alla þáttakendur.
for i = 1 : 16500

    for j = 1 : length(VariableList)
       Lateral(j) = VariableList{j}.data(i,2);
       AnteriorPosterior(j) = VariableList{j}.data(i, 3);
    end
    
    % Til að gögnin vinni ekki á móti hvoru öðru þegar tekið er meðaltal (sumar
    % tölurnar eru mínustölur) þá er tekið "abs" af öllum gögnunum. þ.e. mínus-
    % tölunum breytt í plústölur
    meanLateral(i) = mean(abs(Lateral));
    meanAnteriorPosterior(i) = mean(abs(AnteriorPosterior));
    
end

% Fyrst er lögð fram núlltilgáta um að enginn munur sé á milli tímabila, ef
% svo er þá þarf ekki að halda áfram að svara spurningu um hvort
% einstaklingar læri á milli tímabila þar sem enginn munur er á milli
% þeirra.
% Er munur á milli Lateral tímabila?
LatQ1 = meanLateral(1501:5250);
LatQ2 = meanLateral(5251:9000);
LatQ3 = meanLateral(9001:12750);
LatQ4 = meanLateral(12751:16500);
QLateralAll =[LatQ1; LatQ2; LatQ3; LatQ4];
rotatedQAll = rot90(QLateralAll)
timabil = {'Q1' 'Q2' 'Q3' 'Q4'}
p = anova1(rotatedQAll, timabil);   % P-gildið nær ekki yfir 95% öryggisbil
                                    % sem þýðir að það sé munur á milli tímabila.
                                    % Því þarf að halda áfram að svara
                                    % spurningu um hvort dreifnin minnki á
                                    % milli Q1 og að Q4.
                                    
% Er munur á milli Anterior/Posterior tímabila?
PosQ1 = meanAnteriorPosterior(1501:5250);
PosQ2 = meanAnteriorPosterior(5251:9000);
PosQ3 = meanAnteriorPosterior(9001:12750);
PosQ4 = meanAnteriorPosterior(12751:16500);
QLateralAll =[PosQ1; PosQ2; PosQ3; PosQ4];
rotatedQAll = rot90(QLateralAll)
timabil = {'Q1' 'Q2' 'Q3' 'Q4'}
p = anova1(rotatedQAll, timabil);   % P-gildið nær ekki yfir 95% öryggisbil
                                    % sem þýðir að það sé munur á milli tímabila.
                                    % Því þarf að halda áfram að svara
                                    % spurningu um hvort dreifnin minnki á
                                    % milli Q1 og að Q4.

% Næst er ábyggilega best að bera saman standard deviation (std) á
% milli tímabilana til að skoða hversu dreifð gögnin eru.

% Finna meðaldreifni á fyrir alla einstaklinga á Q1 - Q4
meanLatQ1 = mean(meanLateral(1501:5250));
meanLatQ2 = mean(meanLateral(5251:9000));
meanLatQ3 = mean(meanLateral(9001:12750));
meanLatQ4 = mean(meanLateral(12751:16500));
meanLatAll = [meanLatQ1, meanLatQ2, meanLatQ3, meanLatQ4];
meanPosQ1 = mean(meanAnteriorPosterior(1501:5250));
meanPosQ2 = mean(meanAnteriorPosterior(5251:9000));
meanPosQ3 = mean(meanAnteriorPosterior(9001:12750));
meanPosQ4 = mean(meanAnteriorPosterior(12751:16500));
meanPosAll = [meanPosQ1, meanPosQ2, meanPosQ3, meanPosQ4];

% Finna staðalfrávik á fyrir alla einstaklinga á Q1 - Q4
stdLatQ1 = std(meanLateral(1501:5250));
stdLatQ2 = std(meanLateral(5251:9000));
stdLatQ3 = std(meanLateral(9001:12750));
stdLatQ4 = std(meanLateral(12751:16500));
stdLatAll = [stdLatQ1, stdLatQ2, stdLatQ3, stdLatQ4];
stdPosQ1 = std(meanAnteriorPosterior(1501:5250));
stdPosQ2 = std(meanAnteriorPosterior(5251:9000));
stdPosQ3 = std(meanAnteriorPosterior(9001:12750));
stdPosQ4 = std(meanAnteriorPosterior(12751:16500));
stdPosAll = [stdPosQ1, stdPosQ2, stdPosQ3, stdPosQ4];

% Teikna upp errorbar
figure
subplot(1,2,1)
hold on
ax = axis;
errorbar(meanLatAll,stdLatAll, '.', 'Vertical', 'MarkerFaceColor','red');
axis([0 5 2 4])
title('Lateral-Hreyfing');
xlabel ('Tímabil Q1-Q4');
ylabel ('Staðalfrávik');
legend('Q1 - Q4 Lateral');

% Teikna upp errorbar
subplot(1,2,2)
ax = axis;
errorbar(meanPosAll,stdPosAll, '.', 'Vertical', 'MarkerFaceColor','blue');
axis([0 5 5 11])
title('Anterior/Posterior - Hreyfing');
xlabel ('Tímabil Q1-Q4');
ylabel ('Staðalfrávik');
legend('Q1-Q4 Posterior/Anterior');
    
% Hvað sést útfrá á teikningum?

%% 7. Gerið greiningu á muninum milli þess að hafa opin augu vs að hafa lokuð augu.
fprintf('7. Gerið greiningu á muninum milli þess að hafa opin augu vs að hafa lokuð augu. \n')

for i = 1 : 16500
    openCounter = 1;
    closedCounter = 1;
    for j = 1 : length(VariableList)
        if VariableList{j}.type == 'open'
            openLateral(openCounter) = VariableList{j}.data(i,2);
            openAnteriorPosterior(openCounter) = VariableList{j}.data(i, 3);
            openCounter = openCounter + 1;
        else
            closedLateral(closedCounter) = VariableList{j}.data(i,2);
            closedAnteriorPosterior(closedCounter) = VariableList{j}.data(i, 3);
            closedCounter = closedCounter + 1;
        end
    end
 
    % Meðaltal fyrir opin og lokuð augu, bæði Lateral og Ant/Pos
    % Meðaltöl reiknuð með absolute gildum.
    meanAbsOpenLateral(i) = mean(abs(openLateral));
    meanAbsOpenAnteriorPosterior(i) = mean(abs(openAnteriorPosterior));
    meanAbsClosedLateral(i) = mean(abs(closedLateral));
    meanAbsClosedAnteriorPosterior(i) = mean(abs(closedAnteriorPosterior));
end

% útskýring á ttest2, af netinu:
% returns a test decision for the null hypothesis that the data in vectors x 
% and y comes from independent random samples from normal distributions with 
% equal means and equal but unknown variances, using the two-sample t-test. 
% The alternative hypothesis is that the data in x and y comes from populations 
% with unequal means. The result h is 1 if the test rejects the null hypothesis 
%at the 5% significance level, and 0 otherwise.
ttest2(meanAbsOpenLateral,meanAbsClosedLateral)                       % Segir að það sé munur á milli
ttest2(meanAbsOpenAnteriorPosterior,meanAbsClosedAnteriorPosterior)   % Segir að það sé munur á milli
                                                                % Öll test segja að það sé munur á milli þess að hafa augun opin og lokuð
figure;
hold on
subplot(1,2,1);
plot(meanAbsOpenLateral,meanAbsOpenAnteriorPosterior,'r.');
subplot(1,2,2);
plot(meanAbsClosedLateral,meanAbsClosedAnteriorPosterior,'b.');
hold off

figure;
subplot(2,2,1);
hist(meanAbsOpenLateral)
subplot(2,2,2);
hist(meanAbsClosedLateral)
subplot(2,2,3);
hist(meanAbsOpenAnteriorPosterior)
subplot(2,2,4);
hist(meanClosedAnteriorPosterior)


%% 8. Hvaða einstaklingur stóð sig best í prófinu miðað við ykkar niðurstöður
fprintf('8. Hvaða einstaklingur stóð sig best í prófinu miðað við ykkar niðurstöður \n')

% Tvær aðferðir notaðar.
    % 1. Sá einstaklingur með lægsta meðaltalið verður valin bestur.
    %    Mínustölum umbreytt yfir í plústölur fyrir Lateral og 
    %    Anterior/Posterior sem svo eru lagðar saman og meðaltal tekið. 

    % 2. Sá einstaklingur sem færði sig samtals styst frá núllinu
    %    Hér er reiknuð samtalan, fyrir hvern einasta einstakling, hversu 
    %    langt hvert hnit (Lateral, AnteriorPosterior) fór frá
    %    núllpunkti(0,0) við hverja mælingu

% AÐFERÐ 1:
fprintf('AÐFERÐ 1: \n')

for j = 1 : length(VariableList)
       
    % Samtala reiknuð
    result(j) = sum(abs(VariableList{j}.data(:,2)) + abs(VariableList{j}.data(:,3))) / 16500;
    
    % Grípum nafnið með
    name(j) = VariableList{j}.name;
    
end

% Sá einstaklingur sem fór samtals styst frá núllpunkti og stóð sig
% þar af leiðandi best í prófinu
smallest = result(1);
for j = 2 : length(result)
    if result(j) < smallest
        smallest = result(j);
    end
end

% Finnur einstaklinginn sem er stysst frá núlli
winner = name(find(result == smallest));
fprintf('Sigurvegari = %s \n', winner)


% AÐFERÐ 2:
fprintf('AÐFERÐ 2: \n')

for j = 1 : length(VariableList)
       
    % Tölur næstar núlli reiknaðar
    %  hypot er sama og "sqrt((x-0).^2 + (y-0).^2)"
    result(j) = sum(hypot((VariableList{j}.data(:,2)),(VariableList{j}.data(:,3))));
    result(j) = (result(j) / 16500);
    % Grípum nafnið með
    name(j) = VariableList{j}.name;
    
end

% Sá einstaklingur sem fór samtals styst frá núllpunkti og stóð sig
% þar af leiðandi best í prófinu
smallest = result(1);
for j = 2 : length(result)
    if result(j) < smallest
        smallest = result(j);
    end
end

% Finnur einstaklinginn sem er stysst frá núlli
winner = name(find(result == smallest));
fprintf('Sigurvegari = %s \n', winner)
% Báðar aðferðirnar benda á "SUB24_closed" sem besti einstaklingurinn.




