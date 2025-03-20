stimLoc = NaN(44,1);

p = 0;

while p < 0.999
    
    stimLoc = -1 + (1-(-1)).*rand(44,1);
    pd = makedist('uniform','lower',-1,'upper',1);
    [~,p] = kstest(stimLoc,'cdf',pd);
    
end

stimLoc = stimLoc*pi;