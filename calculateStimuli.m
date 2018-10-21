function [ ] = calculateStimuli(stimuli)
%{
    Á meðan lykkjan fer í gegnum hvert einasta stak í mælingum,
    skiptir hún á milli undir lykkja í hvers skipti sem stimulus
    færist á milli 20 og 59. Í hvert skipti sem hún færist á milli 
    telur "stimuliCounter" stimulusinn.

    Í hvert skipti sem mælingin er undir stimulus (59) er tíminn sem það
    tekur mældur og geymdur í "stimuliCurrentTime"
    Eftir að hvert stimulus tímabil klárast er tíminn sem það tók safnað
    fyrir í "stimuliTotalTimes"

    Þegar aðallykkjan klárast er meðaltal allra mælinga reiknað.
%} 


stimuliTime = stimuli(:, 1);            % Filtera allar stimuli time mælingar
stimulusNm = stimuli(:, 2);             % Filtera allar "Torque" mælingar
stimulusLength = length(stimulusNm);    % Fjöldi mælingar

stimuliCounter = 0;             % Upphafspunktur fyrir fjölda stimulusa
stimuliTotalTimes = [];         % Samlagning á fjölda tímabila sem stimulus stóð yfir
stimuliTotalTimesCounter = 1;
i = 1;

while i ~= stimulusLength
    
    while stimulusNm(i) == 20 && i ~= stimulusLength
        i = i + 1;
    end
    
    stimuliCounter = stimuliCounter + 1; 
    
    stimuliCurrentTime = [];
    stimuliCurrentTimeCounter = 0;
    
    while stimulusNm(i) == 59 && i ~= stimulusLength
        stimuliCurrentTimeCounter = stimuliCurrentTimeCounter + 1;
        stimuliCurrentTime(stimuliCurrentTimeCounter) = stimuliTime(i);
        i = i + 1;
    end
    % Geymi tímalengd hvers stimulus fyrir sig
    stimuliTotalTimes(stimuliTotalTimesCounter) = stimuliCurrentTime(end) - stimuliCurrentTime(1);
    stimuliTotalTimesCounter = stimuliTotalTimesCounter + 1;
end

StimuliMeanTime = sum(stimuliTotalTimes) / stimuliCounter;

fprintf('Heildarfjöldi stimulu er %d\n', stimuliCounter);
fprintf('Meðaltími hvers stimulus er %.2f sekúntur\n', StimuliMeanTime); 

end