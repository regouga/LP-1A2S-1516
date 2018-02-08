/**********************************************************************************************************************/
/********************************************* INSTITUTO SUPERIOR TECNICO *********************************************/
/**************************************** Logica para Programacao — 2015-2016 *****************************************/
/**************************+++++++++++++++******* Projeto - Grupo 8-AL *******************+++++++++++++++**************/
/*************+++++++++++++++******** Duarte Galvao, 83449 / Miguel Regouga, 83530 *********+++++++++++++++************/
/**********************************************************************************************************************/



/**********************************************************************************************************************/
/*************************************************** MOVS_POSSIVEIS ***************************************************/
/**********************************************************************************************************************/

    movs_possiveis(Lab, PosA, Movs, Poss) :- buscaCel(Lab, PosA, Cel),
                                             negaCel(Cel, N_Cel),
                                             movsDaCel(PosA, N_Cel, MovsP),
                                             anulaMovs(Movs, MovsP, Poss).
                                             

                                             
/************************************************ PREDICADOS AUXILIARES ***********************************************/

    % buscaCel(Labirinto, Coordenada X, Coordenada Y, El) afirma que El e o elemento da posicao (X,Y) do labirinto
        buscaCel(Lab, (X, Y), El) :- selecLst(Lab, X, Col),
                                     selecLst(Col, Y, El).

    % negaCel(Celula, Celula negada) afirma que Celula negada e a negacao da celula Celula
        negaCel(Cel, N_Cel) :- subtract([c,b,e,d], Cel, N_Cel).

    % movsDaCel(Pos, Celula negada, Movs) afirma que a lista Movs e a dos movimentos que a 
    % celula (negada) (da posicao Pos) permite
        movsDaCel(_, [], []).
        movsDaCel(Pos, [P1|R1], [P2|R2]) :- aplicaMov(Pos, P1, P2),
                                            movsDaCel(Pos, R1, R2).

    % anulaMovs(Movs_feitos, Movs_possiveis, Res) afirma que Res e Movs_possiveis depois 
    % de anuladas as posicoes anteriores
        anulaMovs([], Res, Res).
        anulaMovs([P|R], MovsP, Res) :- elimMov(MovsP, P, MovsP1),
                                        anulaMovs(R, MovsP1, Res).

    % selecLst(Lista, N, El) afirma que El e o N-esimo elemento da lista
        selecLst([P | _], 1, P).
        selecLst([_ | R], X, El) :- X > 1,
                                    X1 is X - 1,
                                    selecLst(R, X1, El).

    % aplicaMov(PosInic, Mov, PosFinal) afirma que PosFinal e a PosInic depois de aplicado o movimento Mov
        aplicaMov((X,Y), c, (c, X1, Y)) :- X1 is X - 1.
        aplicaMov((X,Y), b, (b, X1, Y)) :- X1 is X + 1.
        aplicaMov((X,Y), e, (e, X, Y1)) :- Y1 is Y - 1.
        aplicaMov((X,Y), d, (d, X, Y1)) :- Y1 is Y + 1.

    % elimMov(ListaMov, Mov, Res) afirma que Res e a ListaMov apos removida a ocorrencia de Mov
        elimMov([], _, []).
        elimMov([(_, X, Y)|R], (_, X, Y), R).
        elimMov([(M, X, Y)|R1], Mov, [(M, X, Y)|R2]) :- Mov \= (_,X,_), !,
                                                        elimMov(R1, Mov, R2).
        elimMov([(M, X, Y)|R1], Mov, [(M, X, Y)|R2]) :- Mov \= (_,_,Y), !,
                                                        elimMov(R1, Mov, R2).



/**********************************************************************************************************************/
/***************************************************** DISTANCIA ******************************************************/
/**********************************************************************************************************************/

    distancia((L1, C1), (L2, C2), Dist) :- Dist is abs(L1 - L2) + abs(C1 - C2).



/**********************************************************************************************************************/
/**************************************************** ORDENA_POSS *****************************************************/
/**********************************************************************************************************************/
                                                            
    ordena_poss([P|R], Poss_ord, Pos_inicial, Pos_final) :- ordena_poss2(R, [P1|R1], [P], Pos_inicial),
                                                            ordena_poss3(R1, Poss_ord, [P1], Pos_final).
    
    /* ordena_poss2 executa um insertion sort na ordem decrescente */
    ordena_poss2([], Poss_ord, Poss_ord, _).
    ordena_poss2([P|R], Poss_ord, Acc, Pos) :- insereD(Acc, P, Pos, Acc1),
                                               ordena_poss2(R, Poss_ord, Acc1, Pos).
    
    /* ordena_poss3 executa um insertion sort na ordem crescente */
    ordena_poss3([], Poss_ord, Poss_ord, _).
    ordena_poss3([P|R], Poss_ord, Acc, Pos) :- insere(Acc, P, Pos, Acc1),
                                               ordena_poss3(R, Poss_ord, Acc1, Pos).

    
/************************************************ PREDICADOS AUXILIARES ***********************************************/

    % insere(Lista, Elemento, PosI, PosF, Res) afirma que res e a Lista apos inserido ordenadamente 
    % o Elemento (tendo em conta a distancia a Pos)
        insere([], El, _, [El]).

        insere([P|R], El, Pos, [El,P|R]) :- distMov(El, Pos, D1),
                                            distMov(P, Pos, D2), D1 < D2.

        insere([P|R], El, Pos, [P|Res]) :- distMov(El, Pos, D1),
                                           distMov(P, Pos, D2), D1 >= D2,
                                           insere(R, El, Pos, Res).
    
    % insereD(Lista, Elemento, PosI, PosF, Res) afirma que res e a Lista apos inserido ordenadamente 
    % (em ordem decrescente) o Elemento (tendo em conta a distancia a Pos)
        insereD([], El, _, [El]).
        insereD([P|R], El, Pos, [El,P|R]) :- distMov(El, Pos, D1),
                                             distMov(P, Pos, D2), D1 > D2.

        insereD([P|R], El, Pos, [P|Res]) :- distMov(El, Pos, D1),
                                            distMov(P, Pos, D2), D1 =< D2,
                                            insereD(R, El, Pos, Res).
    
    % distMov(A, B, D) afirma que a distancia entre o resultado do movimento A e o ponto B
        distMov((_,X,Y), B, D) :- distancia((X,Y), B, D).



/**********************************************************************************************************************/
/***************************************************** RESOLVE1 *******************************************************/
/**********************************************************************************************************************/

    resolve1(Lab, Pos_inicial, Pos_final, Movs) :- Pos_inicial = (X,Y), 
                                                   resolve1(Lab, Pos_inicial, Pos_final, [(i,X,Y)], Movs).
    
    resolve1(_,_, (X,Y), Ac, Ac) :- last(Ac, (_,X,Y)), !.

    resolve1(Lab, Pos_inicial, Pos_final, Ac, Movs) :- last(Ac, (_,X,Y)),   % encontra o ultimo elemento da lista
                                                       movs_possiveis(Lab, (X,Y), Ac, [P|_]),
                                                       append(Ac, [P], Ac1),   % junta o movimento ao acumulador
                                                       resolve1(Lab, Pos_inicial, Pos_final, Ac1, Movs).

    resolve1(Lab, Pos_inicial, Pos_final, Ac, Movs) :- last(Ac, (_,X,Y)),
                                                       movs_possiveis(Lab, (X,Y), Ac, [_,S|_]),
                                                       append(Ac, [S], Ac1),
                                                       resolve1(Lab, Pos_inicial, Pos_final, Ac1, Movs).

    resolve1(Lab, Pos_inicial, Pos_final, Ac, Movs) :- last(Ac, (_,X,Y)),
                                                       movs_possiveis(Lab, (X,Y), Ac, [_,_,T|_]),
                                                       append(Ac, [T], Ac1),
                                                       resolve1(Lab, Pos_inicial, Pos_final, Ac1, Movs).

    resolve1(Lab, Pos_inicial, Pos_final, Ac, Movs) :- last(Ac, (_,X,Y)),
                                                       movs_possiveis(Lab, (X,Y), Ac, [_,_,_,Q]),
                                                       append(Ac, [Q], Ac1),
                                                       resolve1(Lab, Pos_inicial, Pos_final, Ac1, Movs).

    % O predicado resolve1 tera ate 4 ramos diferentes para cada movimento.



/**********************************************************************************************************************/
/***************************************************** RESOLVE2 *******************************************************/
/**********************************************************************************************************************/

    resolve2(Lab, Pos_inicial, Pos_final, Movs) :- Pos_inicial = (X,Y), 
                                                   resolve2(Lab, Pos_inicial, Pos_final, [(i,X,Y)], Movs).
    
    resolve2(_,_, (X,Y), Ac, Ac) :- last(Ac, (_,X,Y)), !.
    
    resolve2(Lab, Pos_inicial, Pos_final, Ac, Movs) :- last(Ac, (_,X,Y)),
                                                       movs_possiveis(Lab, (X,Y), Ac, Poss),
                                                       ordena_poss(Poss, [P|_], Pos_inicial, Pos_final),
                                                       append(Ac, [P], Ac1),
                                                       resolve2(Lab, Pos_inicial, Pos_final, Ac1, Movs).

    resolve2(Lab, Pos_inicial, Pos_final, Ac, Movs) :- last(Ac, (_,X,Y)),
                                                       movs_possiveis(Lab, (X,Y), Ac, Poss),
                                                       ordena_poss(Poss, [_,S|_], Pos_inicial, Pos_final),
                                                       append(Ac, [S], Ac1),
                                                       resolve2(Lab, Pos_inicial, Pos_final, Ac1, Movs).

    resolve2(Lab, Pos_inicial, Pos_final, Ac, Movs) :- last(Ac, (_,X,Y)),
                                                       movs_possiveis(Lab, (X,Y), Ac, Poss),
                                                       ordena_poss(Poss, [_,_,T|_], Pos_inicial, Pos_final),
                                                       append(Ac, [T], Ac1),
                                                       resolve2(Lab, Pos_inicial, Pos_final, Ac1, Movs).

    resolve2(Lab, Pos_inicial, Pos_final, Ac, Movs) :- last(Ac, (_,X,Y)),
                                                       movs_possiveis(Lab, (X,Y), Ac, Poss),
                                                       ordena_poss(Poss, [_,_,_,Q], Pos_inicial, Pos_final),
                                                       append(Ac, [Q], Ac1),
                                                       resolve2(Lab, Pos_inicial, Pos_final, Ac1, Movs).