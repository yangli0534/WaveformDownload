% load waveform to sg
clc; 
close all; 
clear all;

io = agt_newconnection('gpib',0,20);
[status, status_description,query_result] = agt_query(io,'*idn?');
if (status < 0) return; end

fs = 40e6;
T = 1 / fs;
t = [ 1 : 10000 ] * T;
f1 = 1e6
f2 = 3e6;
IQData = exp( j * 2 * pi * f1 * t ) + exp( j * 2 * pi * f2 * t );
figure; plot(t,real(IQData),'r-*', t, imag(IQData));

maximum = max( [ real( IQData ) imag( IQData ) ] );
IQData = 0.7 * IQData / maximum;

Markers = zeros(2,length(IQData));
Markers(1,:) = sign(real(IQData));
Markers(2,:) = sign(imag(IQData));
Markers = (Markers + 1)/2;

[status, status_description] = agt_sendcommand(io, 'SOURce:FREQuency 3000000000');
[status, status_description] = agt_sendcommand(io, 'POWer 0');

[status, status_description] = agt_waveformload(io, IQData, 'agtsample', 40000000, 'play','no_normscale', Markers);


[status, status_description] = agt_waveformload(io, IQData);
 [status, status_description ] = agt_sendcommand( io, 'OUTPut:STATe ON' );




