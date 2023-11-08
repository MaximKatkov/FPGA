clear
clc
% Задача фильтрации звука. Создадим звуковой сигнал с высокочастотным шумом,
% а затем удалим шум с помощью преобразования Фурье.

% SAMPLE_RATE = 2000 ;  %частота дискритизации (колл-во отсчётов)
% DURATION = 1 ; % длительность сигнала (сек)
% 
% nice_tone = generate_sine_wave(100, SAMPLE_RATE, DURATION);
% noise_tone = generate_sine_wave(700, SAMPLE_RATE, DURATION);
% noise_tone2 = generate_sine_wave(1000, SAMPLE_RATE, DURATION);
% 
% noise_tone = noise_tone * 0.3;
% noise_tone2 = noise_tone2 * 0.2;
% mixed_tone = nice_tone + noise_tone + noise_tone2;
% 
% % нормализация, масштабирование сигнала под целевой формат. 
% % В нашем случае это 16-битное целое число, тогда амплитуда 
% % будет меняться в диапазоне от -32768 до 32767
% 
% normalized_tone = ((mixed_tone / max(mixed_tone)) * 32767);

normalized_tone = BPSK_modulatorclc(2e6);

figure(1)
    plot(normalized_tone,'g');
    title('Signal');
    xlabel('X');
    ylabel('Y');

SAMPLE_RATE = length(normalized_tone);
fprintf(' Частота дискритизации,(колл-во отсчётов) = %d.\n' , SAMPLE_RATE);
% Получения спектра от FFT и встроенной функции fft

% Y = FFT(normalized_tone);
% %y = fft(normalized_tone);
% 
 xf_half = linspace(0, SAMPLE_RATE/2, SAMPLE_RATE/2 );
% xf = cat(2, xf_half, linspace(-(SAMPLE_RATE/2) , 0, (SAMPLE_RATE/2)));
% 
% figure(2)
% %     plot(xf,Y,xf,abs(y));
% plot(xf,Y, '*-');
% hold on
% %plot(xf,abs(y));
% title('Spectrum');
% xlabel('f');
% ylabel('S(f)');
    
% Получения спектра (в положительной области частот) от FFT2 

Y_half = FFT2(normalized_tone);

max_Ampldt = max(Y_half);
fprintf(' Максимальная амплитуда = %d.\n' , max_Ampldt);

index_f = find(Y_half == max_Ampldt);
fprintf(' Cоответствущая частота = %d.\n' ,xf_half(index_f));

figure(3)
    plot(xf_half,Y_half,'b+-');
    title('Spectrum');
    xlabel('f');
    ylabel('S(f)');
    
% % Решим задачу фильтрации звука 
% % Если мы установим мощность бина равной нулю, соответствующая частота 
% % перестанет присутствовать в результирующем сигнале во временной области
%     
% % Максимальная частота составляет половину частоты дискретизации
% points_per_freq = length(xf_half) / (SAMPLE_RATE / 2);
% 
% % Наша целевая частота - 700 Гц и 100 Гц
% target_idx = (points_per_freq * 700);
% target_idx2 = (points_per_freq * 1000);
% 
% % Обнулим Y_half для индексов около целевой частоты (+/- 30(в ед. xf_half))
% 
% Y_half(target_idx-30:target_idx+30) = 0 ;
% Y_half(target_idx2-30:target_idx2+30) = 0 ;
% 
% figure(4)
%     plot(xf_half,Y_half);
%     title('Spectrum');
%     xlabel('f');
%     ylabel('S(f)');
%     
% % Выполнив обратное преобразование Фурье, получим интресующий нас сигнал
% % во временной области
% 
% X_half = ifft(Y_half);
% 
% t = (0:length(X_half)-1);
% 
% figure(5)
%     plot(t,X_half);
%     title('Signal');
%     xlabel('X');
%     ylabel('Y');
    
  



