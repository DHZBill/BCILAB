%{
for i = -1000:10:1000
    if i < 0 
        
        sound(-100)
    else
        sound(100)
    end
end
%}
 fs = 8000;

%Generate time values from 0 to T seconds at the desired rate.
        T = 2; % 2 seconds duration
        t = 0:(1/fs):T;

%Generate a sine wave of the desired frequency f at those times.
       f = 130.81;
       a = 0.5;
       y = a*sin(2*pi*f*t);
       sound(y, fs);

