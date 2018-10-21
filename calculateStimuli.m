function [ ] = calculateStimuli(stimuli)
%{
    � me�an lykkjan fer � gegnum hvert einasta stak � m�lingum,
    skiptir h�n � milli undir lykkja � hvers skipti sem stimulus
    f�rist � milli 20 og 59. � hvert skipti sem h�n f�rist � milli 
    telur "stimuliCounter" stimulusinn.

    � hvert skipti sem m�lingin er undir stimulus (59) er t�minn sem �a�
    tekur m�ldur og geymdur � "stimuliCurrentTime"
    Eftir a� hvert stimulus t�mabil kl�rast er t�minn sem �a� t�k safna�
    fyrir � "stimuliTotalTimes"

    �egar a�allykkjan kl�rast er me�altal allra m�linga reikna�.
%} 


stimuliTime = stimuli(:, 1);            % Filtera allar stimuli time m�lingar
stimulusNm = stimuli(:, 2);             % Filtera allar "Torque" m�lingar
stimulusLength = length(stimulusNm);    % Fj�ldi m�lingar

stimuliCounter = 0;             % Upphafspunktur fyrir fj�lda stimulusa
stimuliTotalTimes = [];         % Samlagning � fj�lda t�mabila sem stimulus st�� yfir
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
    % Geymi t�malengd hvers stimulus fyrir sig
    stimuliTotalTimes(stimuliTotalTimesCounter) = stimuliCurrentTime(end) - stimuliCurrentTime(1);
    stimuliTotalTimesCounter = stimuliTotalTimesCounter + 1;
end

StimuliMeanTime = sum(stimuliTotalTimes) / stimuliCounter;

fprintf('Heildarfj�ldi stimulu er %d\n', stimuliCounter);
fprintf('Me�alt�mi hvers stimulus er %.2f sek�ntur\n', StimuliMeanTime); 

end