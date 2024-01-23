function runme(subID, if_trigger_scanner, stim_set, num_runs, task_num, start_run)
% Prompts experimenter for session parameters and executes functional
% localizer experiment used to define regions in high-level visual cortex
% selective to faces, places, bodies, and printed characters.
%
% Inputs (optional):
%   1) subID -- session-specific identifier (e.g., particpant's initials)
%   2) if_trigger_scanner -- option to trigger scanner (0 = no, 1 = yes)
%   3) stim_set -- stimulus set (1 = standard, 2 = alternate, 3 = both)
%   4) num_runs -- number of runs (stimuli repeat after 2 runs/set)
%   5) task_num -- which task (1 = 1-back, 2 = 2-back, 3 = oddball)
%   6) start_run -- run number to begin with (if sequence is interrupted)
%
% Version 3.0 8/2017
% Anthony Stigliani (astiglia@stanford.edu)
% Department of Psychology, Stanford University
% 
% Use by Yongning Lei (t.lei@bcbl.eu)
% BCBL

%% things you may wanna change:
%  in fLocSession.m, 
%     properties (Constant)
%         count_down = 12; % pre-experiment countdown (secs)
%         stim_size = 768; % size to display images in pixels   THIS ONE
%         MAY BE CHANGED!
%        
%         wait_dur = 1;          % seconds to wait for response





%% add paths and check inputs

addpath('functions');

% session subID
if nargin < 1
    subID = [];
    while isempty(deblank(subID))
        subID = input('Subject initials : ', 's');
    end
end

% option to trigger scanner
if nargin < 2
    if_trigger_scanner = -1;
    while ~ismember(if_trigger_scanner, 0:1)
        if_trigger_scanner = input('Trigger scanner? (0 = no, 1 = yes) : ');
    end
end

% which stimulus set/s to use
if nargin < 3
    stim_set = -1;
    while ~ismember(stim_set, 1:2)
        stim_set = input('Which stimulus set? (1 = mini_stimulus_set, 2 = fLoc_other_VOTC_set) : ');
    end
end

% number of runs to generate
if nargin < 4
    num_runs = -1;
    while ~ismember(num_runs, 1:24)
        num_runs = input('How many runs? : ');
    end
end

% which task to use
if nargin < 5
    task_num = -1;
    while ~ismember(task_num, 1:3)
        %task_num = input('Which task? (1 = 1-back, 2 = 2-back, 3 = oddball) : ');
        task_num = input('Which task? (1 = 1-back, 2 = 2-back, 3 = oddball, 4=passive_reading) : ');
    end
end

% which run number to begin executing (default = 1)
if nargin < 6
    start_run = 1;
end


%% initialize session object and execute experiment

% setup fLocSession and save session information
session = fLocSession(subID, if_trigger_scanner, stim_set, num_runs, task_num);
session = load_seqs(session);
session_dir = (fullfile(session.exp_dir, 'data', session.id));
if ~exist(session_dir, 'dir') == 7
    mkdir(session_dir);
end
fpath = fullfile(session_dir, [session.id '_fLocSession.mat']);
save(fpath, 'session', '-v7.3');

% execute all runs from start_run to num_runs and save parfiles
fname = [session.id '_fLocSession.mat'];
fpath = fullfile(session.exp_dir, 'data', session.id, fname);
for rr = start_run:num_runs
    session = run_exp(session, rr);
    save(fpath, 'session', '-v7.3');
end
write_parfiles(session);

end
