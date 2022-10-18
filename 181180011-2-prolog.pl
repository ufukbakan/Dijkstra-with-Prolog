% Ufuk Bakan - Gazi University - 181180011 - 2020
% main. ile çalıştırınız
% Uzaklik grafi yoksa initialize et:
dijkstra(Noktalar, Kenarlar, Baslangic, AlinanYol, [], ZiyaretGrafi, I, NextNode) :-
    length(ZiyaretGrafi,LZ),
    LZ < 1,
    length(Noktalar, LN),
    format('Baslangic noktasi ~w olarak secildi~n', [Baslangic]),
    diziOlustur(inf,LN,Arr),diziElemanNDegis(Arr,Baslangic,0,Arr2),dijkstra(Noktalar,Kenarlar,Baslangic,AlinanYol,Arr2,ZiyaretGrafi,I,NextNode)
.

% Ziyaret grafi yoksa initialize et:
dijkstra(Noktalar, Kenarlar, Baslangic, AlinanYol, UzaklikGrafi, [], I, NextNode) :-
    length(UzaklikGrafi,LU),
    LU > 0,
    length(Noktalar,LN),
    diziOlustur(0,LN,Arr),dijkstra(Noktalar,Kenarlar,Baslangic,AlinanYol,UzaklikGrafi,Arr,I,NextNode)
.

dijkstra(Noktalar, Kenarlar, Baslangic, AlinanYol, UzaklikGrafi, ZiyaretGrafi, I, NextNode) :-
    length(UzaklikGrafi,LU),LU > 0, length(ZiyaretGrafi, LZ), LZ > 0,Nexti is I+1,
    length(Kenarlar,LK),
    (
        I < LK ->
        nth0(I,Kenarlar,Kenar),nth0(0,Kenar,KenarBaslangici),nth0(1,Kenar,KenarHedefi),nth0(2,Kenar,KenarAgirligi),
        (
            KenarBaslangici == Baslangic ->
            checkNext(Kenar, ZiyaretGrafi, NextNode, YeniNextNode),Yol is (AlinanYol + KenarAgirligi),nth0(KenarHedefi,UzaklikGrafi,MevcutEnKisa),
            karsilastir(Yol, MevcutEnKisa, KYS),
            (
                KYS > 0 ->
                diziElemanNDegis(UzaklikGrafi,KenarHedefi,Yol,YeniUGrafi),dijkstra(Noktalar,Kenarlar,Baslangic,AlinanYol,YeniUGrafi,ZiyaretGrafi,Nexti,YeniNextNode);
                dijkstra(Noktalar,Kenarlar,Baslangic, AlinanYol, UzaklikGrafi, ZiyaretGrafi, Nexti, YeniNextNode)
            );
            dijkstra(Noktalar, Kenarlar, Baslangic, AlinanYol, UzaklikGrafi, ZiyaretGrafi, Nexti, NextNode)
        );
        diziElemanNDegis(ZiyaretGrafi,Baslangic,1,YeniZGrafi),
        (
            NextNode \= -1 ->
            nth0(NextNode,UzaklikGrafi,EnKisaYol),dijkstra(Noktalar, Kenarlar, NextNode, EnKisaYol, UzaklikGrafi, YeniZGrafi, 0, -1);
            enKisaYollariYaz(UzaklikGrafi, 0)
        )
    )
.

enKisaYollariYaz(UzaklikGrafi, N) :-
    length(UzaklikGrafi,L),
    (
        N < L ->
        nth0(N,UzaklikGrafi,Nth),format('~w. noktaya en kisa uzaklik : ~w~n',[N,Nth]),Next is N+1,enKisaYollariYaz(UzaklikGrafi,Next)
        ;
        write('============'),nl
    )
.

checkNext(_,_,CurrentNextNode,YeniNextNode):-
    CurrentNextNode \= -1, YeniNextNode = CurrentNextNode
.

checkNext(Kenar,ZiyaretGrafi,-1,YeniNextNode) :-
    nth0(1,Kenar,J),nth0(J,ZiyaretGrafi,V),
    (
        V == 0 ->
        YeniNextNode = J;
        YeniNextNode = -1
    )
.

karsilastir(_,inf,1).
karsilastir(A,B,C) :-
    B \= inf,
    (
        A > B ->
        C = -1;
        A == B ->
        C = 0;
        C = 1
    )
.

diziOlustur(X, N, List)  :- 
    findall(X, between(1, N, _), List).

diziElemanNDegis([_|T],0,E,[E|T]).
diziElemanNDegis([H|T],P,E,[H|R]) :-
    P > 0, NP is P-1, diziElemanNDegis(T,NP,E,R).

printArr([X|T]) :-
    length(T, L),
    L > 0,
    format('~w, ',[X]),printArr(T)
.
printArr([X]) :-
    write(X)
.

main :-
    write('Graf YONLUDUR'),
    nl,write('Noktalar Kumesi :'),
    Noktalar = [0,1,2,3], nl,
    write(Noktalar),nl,
    write('Kenarlar Kumesi :'), nl,
    write('Kenar gosterimi : [kaynak , hedef, agirlik]'),
    Kenarlar = [[0,3,4] , [0,2,9] , [1,3,1] , [3,2,2], [2,1,8]],
    nl,write(Kenarlar),nl,nl,
    dijkstra(Noktalar, Kenarlar, 0 , 0, [], [], 0, -1),
    dijkstra(Noktalar, Kenarlar, 1 , 0, [], [], 0, -1),
    dijkstra(Noktalar, Kenarlar, 2 , 0, [], [], 0, -1),
    dijkstra(Noktalar, Kenarlar, 3 , 0, [], [], 0, -1)
.