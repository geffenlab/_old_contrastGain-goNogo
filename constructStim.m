if ~exist(params.stim,'file')
    % make tones
    fprintf('Building stimuli...\n');
    % for each offset
    for i = 1:length(offset)
        tmp = makeTone(Fs,f,sd,1,offset(i)+params.postTargetTime,offset(i),rd,params.filt);
        tone{i} = [tmp zeros(1,.02*Fs)];
    end
    
    % make DRCs
    for i = 1:length(offset)
        for j = 1:params.nNoiseExemplars
            [noise{i,j}] = makeDRC(Fs,rd,params.chordDuration,[params.baseNoiseD ...
                offset(i) - params.baseNoiseD + params.postTargetTime],...
                params.freqs,params.mu,params.sd,params.amp70, ...
                params.filt);
        end
    end
    fprintf('Done\n');
    fprintf('Saving stimuli as %s ', params.stim);
    save(params.stim,'params','noise','tone');
    fprintf(' done\n');
else
    % load it
    fprintf('Loading %s...', params.stim);
    a=load(params.stim);
    noise = a.noise;
    tone = a.tone;
    clear a;
    fprintf(' done\n');
end

% make events
pulseWidth = .02;
for i = 1:size(tone,2)
    tmp = zeros(1,length(tone{i}));
    tEnd = round((offset(i)+params.toneD) * Fs);
    tmp(1:pulseWidth*Fs) = 1;
    tmp(tEnd:tEnd+(pulseWidth*Fs)) = 1;
    events{i} = tmp;
end