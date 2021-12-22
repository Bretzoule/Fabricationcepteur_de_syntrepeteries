(*
 ------------------------------------------------------------------------------------
 -- Fichier           : Projet.pas
 -- Auteur            : LARREGLE Théo <larregleth@eisti.eu> et LEFLOCH Thomas <leflochtho@eisti.eu>
 -- Date de creation  : Tue Dec 11 14:06:01 2018
 --
 -- But               : Permet de générer des mots aléatoirement, par digramme et par trigramme ainsi que des phrases via la méthode des trigrammes.
 -- Remarques         : Readme.txt
 -- Compilation       : fpc
 -- Edition des liens : fpc
 -- Execution         : shell
 ------------------------------------------------------------------------------------
 *)
PROGRAM Projet;
{$mode objfpc}{$H+}
{$codepage UTF8}
{$I-}

USES cwstring, crt, character, sysutils;

CONST alphabet : Widestring               = 'abcdefghijklmnopqrstuvwxyzàâéèêëîïôùûüÿæœç-' ;
CONST pronoms : ARRAY[1..9] OF WideString = ('Je','Tu','Il','Elle','On','Nous','Vous','Ils','Elles');
CONST N                                   = 43;
CONST lexiqueverbe : String               = 'files/verbePremierEtDeuxiemeGroupe.txt';
CONST lexiqueadjectif : String            = 'files/adjectif.txt';
CONST lexiquenomspropres :  String        = 'files/nomPropre.txt';
//CONST lexiqueadverbes :  String           = 'files/adverbe.txt';
CONST lexiquearticles :  String           = 'files/article.txt';
CONST fichierdaide : String               = 'files/helpfile.txt';

TYPE
   champtableau = RECORD
                     prob : LongInt;
                     occ  : LongInt;
                  END;

TYPE tableau3D = ARRAY[0..N,1..N,0..N] OF champtableau;
TYPE tableau1D = ARRAY[1..N] OF champtableau;

word        = RECORD
                 ind  : Integer;
                 maut : WideString;
              END;

overtableau = RECORD
                 one : tableau1D;
                 two : tableau3D;
              END;


TYPE tableau2D = ARRAY[0..N,0..N] OF champtableau;


arg = RECORD

         methode  : Integer;
         nombre   : Integer;
         longueur : Integer;
         fichier  : String;
      END;

sujet = RECORD
           pronom   : WideString;
           personne : Integer;

        END;

conjug = RECORD
            verb       : WideString;
            premgroupe : Boolean;

         END;

Accord = RECORD
            sexe : Boolean; // Feminin si vrai
            qtn  : Boolean; // Pluriel si vrai

         END;

(*
 ------------------------------------------------------------------------------------
 -- Fonction          : creeMotAleatoire (taille : Integer) : WideString
 -- Auteur            : LEFLOCH Thomas <leflochtho@eisti.eu>
 -- Date de creation  : Tue Dec 11 14:09:41 2018
 --
 -- But               : Génère un mot aléatoire à partir d'un alphabet constant.
 -- Remarques         : Aucune
 -- Pré conditions    : Taille non vide.
 -- Post conditions   : Génère un mot aléatoire à partir d'un alphabet constant.
 ------------------------------------------------------------------------------------*)
FUNCTION creeMotAleatoire (taille : Integer) : WideString;
VAR
   mot : WideString;
   i   : Integer;
BEGIN
   mot := '';
   FOR i := 1 TO taille DO
   BEGIN
      mot := (mot + alphabet[Random(43)+1]); // Prends une lettre aléatoire
   END;
   creeMotAleatoire := mot;
END; { creeMotAleatoire }
(*
 ------------------------------------------------------------------------------------
 -- PROCEDURE         : AleaMot(taille : Integer; nbmots : Integer)
 -- Auteur            : LEFLOCH Thomas <leflochtho@eisti.eu>
 -- Date de creation  : Mon Jan 14 10:23:26 2019
 --
 -- But               : Permet de générer un mot avec la méthode aléatoire
 -- Remarques         : Aucune
 -- Pré conditions    : Aucune
 -- Post conditions   : Permet de générer un mot avec la méthode aléatoire
 ------------------------------------------------------------------------------------*)
PROCEDURE AleaMot(taille : Integer; nbmots : Integer);
VAR
   i : Integer;
BEGIN
   //WRITELN(taille);
   IF ((taille <= 0) OR (taille > 100)) THEN
   BEGIN
      WRITELN('Longueur des mots non-valide ou absente, génération d''une longueur aléatoire');
      taille := Random(20);
   END;
   FOR i := 1 TO nbmots DO
   BEGIN
      WRITELN(creeMotAleatoire(taille));
   END;
END; {AleaMot}

/// FONCTION COMMUNES /// FONCTION COMMUNES /// FONCTION COMMUNES /// FONCTION COMMUNES /// FONCTION COMMUNES /// FONCTION COMMUNES /// FONCTION COMMUNES /// FONCTION COMMUNES /// FONCTION COMMUNES /// FONCTION COMMUNES ///

(*
 ------------------------------------------------------------------------------------
 -- Fonction          : conforme(mot : widestring):Boolean
 -- Auteur            : LEFLOCH Thomas <leflochtho@eisti.eu>
 -- Date de creation  : Sat Jan 12 16:42:04 2019
 --
 -- But               : Dire si un mot est conforme ou non en testant chacune de ses lettres par rapport à l'alphabet
 -- Remarques         : Aucune
 -- Pré conditions    : mot non vide
 -- Post conditions   : Dire si un mot est conforme ou non en testant chacune de ses lettres par rapport à l'alphabet
 ------------------------------------------------------------------------------------*)
FUNCTION conforme(mot : widestring):Boolean;
VAR
   i,k,valide : Integer;
BEGIN
   //   WRITELN('Test conformité');
   Valide := 0;
   FOR i := 1 TO length(mot) DO
   BEGIN
      FOR k := 1 TO N DO
      BEGIN
         IF mot[i] = alphabet[k] THEN
         BEGIN
            valide := valide + 1;
         END;
      END;
   END;
   conforme:= ((valide) = (length(mot)));
END; { conforme }

(*
 ------------------------------------------------------------------------------------
 -- Fonction          : alpha(lettre:Widestring):Integer
 -- Auteur            : LARREGLE <larregleth@eisti.eu>
 -- Date de creation  : Fri Dec 14 18:04:13 2018
 --
 -- But               : Convertit une lettre en une valeur correspondant à sa position dans le tableau
 -- Remarques         : Aucune
 -- Pré conditions    : Préconditions
 -- Post conditions   : But
 ------------------------------------------------------------------------------------*)
FUNCTION alpha(lettre:Widechar):Integer;
VAR
   res, i : Integer;
   trouve : Boolean;
BEGIN
   i := 1;
   trouve := false;
   WHILE (( i <= N ) AND NOT(trouve)) DO //Tant que la lettre n'est pas trouvé et dans l'alphabet
   BEGIN
      IF (alphabet[i]=lettre) THEN
      BEGIN
         res := i;
         trouve := true;
      END;
      i := i+1;
   END;
   alpha:= res;
END; { alpha }

(*
 ------------------------------------------------------------------------------------
 -- Fonction          : chiffreToLettre( nb : Integer): Widestring;
 -- Auteur            : LARREGLE <larregleth@eisti.eu>
 -- Date de creation  : Wed Dec 19 09:59:35 2018
 --
 -- But               : Convertit un chiffre en caractère Widestring
 -- Remarques         : Aucune
 -- Pré conditions    : Nombre compris entre 1 et 43
 -- Post conditions   : But
 ------------------------------------------------------------------------------------*)
FUNCTION chiffreToLettre( nb : Integer): Widechar;
VAR
   res : Widechar;
BEGIN
   res := alphabet[nb];
   chiffreToLettre:= res;
END; { chiffreToLettre }

/// TRIGRAMME //// TRIGRAMME /// TRIGRAMME /// TRIGRAMME /// TRIGRAMME /// TRIGRAMME /// TRIGRAMME /// TRIGRAMME /// TRIGRAMME /// TRIGRAMME /// TRIGRAMME /// TRIGRAMME /// TRIGRAMME /// TRIGRAMME /// TRIGRAMME /// TRIGRAMME ///
(*
 ------------------------------------------------------------------------------------
 -- Fonction          : occurenceprems(mot : widestring):Integer
 -- Auteur            : LARREGLE <larregleth@eisti.fr>
 -- Date de creation  : Fri Dec 14 15:23:14 2018
 --
 -- But               : Permet de completer le tableau1D en fonction de la première lettre
 -- Remarques         : Aucune
 -- Pré conditions    : Préconditions
 -- Post conditions   : Permet de completer le tableau1D en fonction de la première lettre
 ------------------------------------------------------------------------------------*)
FUNCTION occurrenceprems(mot : Widestring ; tableauOccurence1D : tableau1D):tableau1D;
BEGIN
   //WRITELN('occurenceprem');
   tableauOccurence1D[alpha(mot[1])].occ := (tableauOccurence1D[alpha(mot[1])].occ)+1;
   occurrenceprems:= tableauOccurence1D;
END; { occurrencedi }

(*
 ------------------------------------------------------------------------------------
 -- Fonction          : occurrencetr(mot : widestring ; occur : tableau): tableau
 -- Auteur            : LARREGLE <larregleth@eisti.eu>
 -- Date de creation  : Wed Jan  9 09:20:28 2019
 --
 -- But               : Stocke dans le tableau trigramme (à trois dimensions) les ocurrences correspondantes
 -- Remarques         : Copié et collé depuis digramme.pas et adapté
 -- Pré conditions    : Préconditions
 -- Post conditions   : But
 ------------------------------------------------------------------------------------*)
FUNCTION occurrencetr(mot2 : Widestring ; tableauOccurence3D : tableau3D): tableau3D;
VAR
   l : Integer;
BEGIN
   tableauOccurence3D[0,alpha(mot2[1]),alpha(mot2[2])].occ := (tableauOccurence3D[0,alpha(mot2[1]),alpha(mot2[2])].occ)+1;
   //WRITELN('Occurencetr');
   FOR l := 1 TO length(mot2)-2 DO
   BEGIN
      // WRITELN(mot2[l], mot2[l+1], mot2[l+2])
      tableauOccurence3D[alpha(mot2[l]),alpha(mot2[l+1]),alpha(mot2[l+2])].occ := (tableauOccurence3D[alpha(mot2[l]),alpha(mot2[l+1]),alpha(mot2[l+2])].occ) + 1 ;
   END;
   //WRITELN('DAB');
   tableauOccurence3D[alpha(mot2[length(mot2)-1]), alpha(mot2[length(mot2)]),0].occ := (tableauOccurence3D[alpha(mot2[length(mot2)-1]), alpha(mot2[length(mot2)]), 0].occ)+1;
   occurrencetr:= tableauOccurence3D;
END; { occurrencetr }
(*
 ------------------------------------------------------------------------------------
 -- Fonction          : probone(tabo : overtableau): overtableau
 -- Auteur            : LARREGLE <larregleth@eisti.eu>
 -- Date de creation  : Thu Jan 17 10:53:01 2019
 --
 -- But               : Calcule pour le tableau une dimension
 -- Remarques         : Aucune
 -- Pré conditions    : Préconditions
 -- Post conditions   : But
 ------------------------------------------------------------------------------------*)
FUNCTION probone(tableauProbSimple : tableau1D): tableau1D;
VAR
   g       : Integer;
   cumule3 : LongInt;
BEGIN
   //WRITELN('probone');
   cumule3 := 0;
   FOR g := 1 TO N DO
   BEGIN
      cumule3 := cumule3 + tableauProbSimple[g].occ; //Nombre d'occurrence totale dans la ligne jusqu'au curseur
      IF (tableauProbSimple[g].occ <> 0) THEN
      BEGIN
         tableauProbSimple[g].prob := cumule3 + tableauProbSimple[g].prob;
      END;
   END;
   tableauProbSimple[N].prob := cumule3;
   probone:= tableauProbSimple;
END; { probone }

(*
 ------------------------------------------------------------------------------------
 -- Fonction          : probtr(tob:tableau):tableau
 -- Auteur            : LARREGLE <larregleth@eisti.eu>
 -- Date de creation  : Wed Jan  9 09:59:59 2019
 --
 -- But               : Calcule la cumulation des nombres en trigramme, pour réaliser les probabilités ainsi que le tableau une dimension
 -- Remarques         : Adaptation au digramme
 -- Pré conditions    : Préconditions
 -- Post conditions   : But
 ------------------------------------------------------------------------------------*)
FUNCTION probtr(tableauProbtri :tableau3D):tableau3D;
VAR
   m,o,p  : Integer;
   cumule : LongInt;
BEGIN
   // WRITELN('ProbTri');
   FOR m := 0 TO N DO
   BEGIN
      FOR o := 1 TO N DO
      BEGIN
         cumule := 0;
         FOR p := 0 TO N DO
         BEGIN
            cumule := cumule + tableauProbtri[m,o,p].occ; //Nombre d'occurrence totale dans une ligne
            IF (tableauProbtri[m,o,p].occ <> 0) THEN
            BEGIN
               tableauProbtri[m,o,p].prob := cumule;
            END
            ELSE
            BEGIN
               tableauProbtri[m,o,p].prob := 0;
            END;
         END;
         tableauProbtri[m,o,N].prob := cumule;   //Indice pour la variable aléatoire pour tirer un nombre aléatoire dans l'intervalle
      END;
   END;
   probtr:= tableauProbtri;
END;
(*
 ------------------------------------------------------------------------------------
 -- Fonction          : ChargelexiqueNrvtri(tab : tableau) : tableau
 -- Auteur            : LARREGLE <larregleth@eisti.eu>
 -- Date de creation  : Fri Dec 14 14:43:42 2018
 --
 -- But               : Charge le lexique et remplie le tableau qui collectera les occurrences
 -- Remarques         : Copié et collé depuis digramme.pas
 -- Pré conditions    : Préconditions
 -- Post conditions   : But
 ------------------------------------------------------------------------------------*)
FUNCTION ChargelexiqueNrvtri(tab : overtableau; namefile : String) : overtableau;
VAR
   ligne : Widestring ;
   fic   : Text;
BEGIN
   //WRITELN('chargement du lexique');
   ligne :=  ' ' ;
   assign (fic, namefile);
   RESET(fic);
   IF ( IOResult <> 0 )THEN
   BEGIN
      WRITELN('le fichier n existe pas');
   END
   ELSE
   BEGIN
      //WRITELN('Fichier trouvé');
      REPEAT
         READLN(fic, ligne) ;
         ligne := lowerCase(ligne);
         IF (conforme(ligne) AND (length(ligne) > 0)) THEN
         BEGIN
            tab.one := occurrenceprems(ligne,tab.one);
            IF (length(ligne) > 1) THEN
            BEGIN
               tab.two := occurrencetr(ligne,tab.two);
            END;
         END;
      UNTIL eof(fic);
      // WRITELN('Occurences calculées');
      close(fic) ;
      tab.two := probtr(tab.two);
      tab.one := probone(tab.one);
   END;
   ChargelexiqueNrvtri := tab;
END; { ChargelexiqueNrv }

(*
 ------------------------------------------------------------------------------------
 -- Fonction          : creer():tableau
 -- Auteur            : LARREGLE <larregleth@eisti.eu>
 -- Date de creation  : Wed Jan  9 09:23:06 2019
 --
 -- But               : Créer les tableaux où seront stockées les variables
 -- Remarques         : Cette fonction est version copié collé du trigramme et adapté au problème
 -- Pré conditions    : Préconditions
 -- Post conditions   : But
 ------------------------------------------------------------------------------------*)
FUNCTION creertri():overtableau;
VAR
   res   : overtableau;
   i,j,k : Integer;
BEGIN
   FOR i := 0 TO N DO
   BEGIN
      res.one[i].occ := 0;
      res.one[i].prob := 0;
      FOR j := 1 TO N DO           // Commence à 1 car il n'existe pas de lettre de début ou de fin dans la deuxième lettre
      BEGIN
         FOR k := 0 TO N DO        // Charge les coordonnées en [x;y;z]
         BEGIN
            res.two[i,j,k].occ := 0;
            res.two[i,j,k].prob := 0;
         END;
      END;
   END;
   creertri:= res;
END; { creertri }
(*
 ------------------------------------------------------------------------------------
 -- Fonction          : TrouveLettreFinTR(tblau : tableau ; character2 : Widestring) : word
 -- Auteur            : LARREGLE <larregleth@eisti.eu>
 -- Date de creation  : Wed Jan  9 10:20:49 2019
 --
 -- But               : Génère un nombre aléatoire qui va permettre de savoir sur quel lettre cela va tomber en prenant en compte le nombre d'occurrences et note l'indice de la colonne.
 -- Remarques         : Aucune
 -- Pré conditions    : Il faut donc que le mot à ce stade soit au moins composé de deux lettres
 -- Post conditions   : But
 ------------------------------------------------------------------------------------*)
FUNCTION TrouveLettreFinTR(tblau : overtableau ; character2 : word) : word;
VAR
   resdumo        : word;
   r              : Integer;
   ohazar,cumule3 : LongInt;
BEGIN
   r := 0;
   IF (length(character2.maut) = 1) THEN
   BEGIN
      cumule3 := tblau.two[0 , alpha(character2.maut[length(character2.maut)]) , N ].prob;
      ohazar := random(cumule3);
      WHILE (tblau.two[0, alpha(character2.maut[1]) ,r].prob <= ohazar) DO
      BEGIN
         r := r + 1;
      END;
      resdumo.ind := r;
      resdumo.maut := character2.maut + chiffreToLettre(r);
   END
   ELSE
   BEGIN
      cumule3 := tblau.two[(alpha(character2.maut[length(character2.maut)-1])),alpha(character2.maut[length(character2.maut)]), N ].prob; // Nombre d'ocurrences dans une ligne en fonction des deux lettres précédentes
      ohazar := random(cumule3);
      WHILE (tblau.two[alpha(character2.maut[length(character2.maut)-1]),alpha(character2.maut[length(character2.maut)]),r].prob <= ohazar) DO
      BEGIN
         r := r + 1;
      END;
      resdumo.ind := r;
      resdumo.maut := character2.maut + chiffreToLettre(r);   // Ajoute la lettre obtenue au mot et récupère l'indice de la dernière lettre
   END;
   //WRITELN(resdumo.maut);
   TrouveLettreFinTR:= resdumo;
END; { TrouveLettreFinTR }


(*
 ------------------------------------------------------------------------------------
 -- PROCEDURE         : affichestat(statis : tableau): tableau
 -- Auteur            : LARREGLE <larregleth@eisti.eu>
 -- Date de creation  : Tue Dec 11 15:04:48 2018
 --
 -- But               : Test pour voir les valeurs au final empilées en créant un tableau similaire à celui présenté au projet
 -- Remarques         : Aucune
 -- Pré conditions    : Préconditions
 -- Post conditions   : But
 ------------------------------------------------------------------------------------*)
FUNCTION affichestattri(statis :overtableau):overtableau;
VAR
   y,x : Integer;
BEGIN
   FOR y := 0 TO N DO
   BEGIN
      FOR x := 1 TO N DO
      BEGIN
         WRITE(statis.two[14,x,y].prob);
         WRITE('  ');
      END;
      WRITELN();
   END;
   affichestattri := statis;
END; { affichestattri }
(*
 ------------------------------------------------------------------------------------
 -- Fonction          : creamotri(tub : tableau) : Widestring
 -- Auteur            : LARREGLE <larregleth@eisti.eu>
 -- Date de creation  : Wed Jan  9 10:13:54 2019
 --
 -- But               : Créer UN mot aléatoire
 -- Remarques         : Repris du digramme, la deuxième lettre est faite en digramme d'un point de vue logique car le nombre de lettres sont insuffisantes pour faire d'abord en trigramme
 -- Pré conditions    : Préconditions
 -- Post conditions   : But
 ------------------------------------------------------------------------------------*)
FUNCTION creamotri(tub : overtableau) : Widestring;
VAR
   marqueur : LongInt;
   res    : word;
   indice  : Integer;
BEGIN
   marqueur := random(tub.one[N].prob);
   indice := 1;
   WHILE (tub.one[indice].prob <= marqueur) DO
   BEGIN
      indice := indice + 1;
   END;
   res.maut := chiffreToLettre(indice); //Commence une lettre prise au hasard
   // WRITELN('First Letter');
   // WRITELN(res.maut);
   res.ind := indice;
   // WRITELN(res.ind);
   WHILE (res.ind <> 0) DO
   BEGIN
      //  WRITELN('Je suis WHILE');
      // WRITELN(res.ind);
      //  WRITELN(res.maut);
      res := TrouveLettreFinTR(tub,res); // Trouve la lettre suivante et récupère l'indice de la lettre ajoutée
   END;
   creamotri:= res.maut;
END;
(*
 ------------------------------------------------------------------------------------
 -- PROCEDURE         : motlongspecialetri(stat : tableau; qtnmots : Integer; longmot : Integer);
 -- Auteur            : LEFLOCH Thomas <leflochtho@eisti.eu>
 -- Date de creation  : Thu Jan 17 16:38:29
 --
 -- But               : Permet de générer un mot d'une longueur définie
 -- Remarques         : Aucune
 -- Pré conditions    : longueur non nulle
 -- Post conditions   : Permet de générer un mot d'une longueur définie
 ------------------------------------------------------------------------------------*)
PROCEDURE motlongspecialetri(stat : overtableau; qtnmots : Integer; longmot : Integer);
VAR
   i,k :  Integer;
   supremot : WideString;
BEGIN
   FOR k := 1 TO qtnmots DO
   BEGIN
      i :=0;
      supremot := creamotri(stat);
      WHILE ((length(supremot) <> longmot+1) AND (i < 10000)) DO
      BEGIN
         supremot := creamotri(stat);
         i:= i+1;
         // WRITELN('je génère un nouveau mot');
      END;
      IF i = 10000 THEN
      BEGIN
         WRITELN('Longueur invalide, génération d''un mot de longueur automatique');
      END;
      WRITELN(supremot);
   END;
END; { motlongspecialetri }

(*
 ------------------------------------------------------------------------------------
 -- PROCEDURE         : TrigrammeZer
 -- Auteur            : LEFLOCH Thomas <leflochtho@eisti.eu>
 -- Date de creation  : Thu Jan 17 13:50:14 2019
 --
 -- But               : Permet de générer un mot en trigrammes
 -- Remarques         : Aucune
 -- Pré conditions    : Aucune
 -- Post conditions   : Permet de générer un mot en trigrammes
 ------------------------------------------------------------------------------------*)
PROCEDURE TrigrammeZer(qtnmots : Integer ; longmot : Integer; namefile : String);
VAR
   stat            : overtableau;
   longueurdemande : Boolean;
   j               : Integer;
BEGIN
   longueurdemande := longmot > 0;
   //WRITELN(longueurdemande);
   WRITELN('Génération d'' un mot avec la méthode des trigrammes');
   stat := creertri();
   //WRITELN('Tableaux trigrammes crées');
   stat := ChargelexiqueNrvtri(stat,namefile);
   //WRITELN('lexique trigramme chargé');
   //stat := probtr(stat);
   //affichestat(stat); Permet d'afficher le tableau des stats complet.
   IF longueurdemande THEN
   BEGIN
      motlongspecialetri(stat, qtnmots, longmot);
   END
   ELSE
   BEGIN
      FOR j := 1 TO qtnmots DO
      BEGIN
         WRITELN(creamotri(stat));
      END;
   END;
END;

(*
 ------------------------------------------------------------------------------------
 -- Fonction          : occurence(mot : widestring):Integer
 -- Auteur            : LEFLOCH Thomas <thomas.lefloch@eisti.fr>
 -- Date de creation  : Fri Dec 14 15:23:14 2018
 --
 -- But               : Compte le nombre de fois que ressort la lettre d'avant et incrit les lettres de début et de fin
 -- Remarques         : Aucune
 -- Pré conditions    : Préconditions
 -- Post conditions   : But
 ------------------------------------------------------------------------------------*)
FUNCTION occurrence(mot : widestring;okure : tableau2D):tableau2D;
VAR
   i   : Integer;
BEGIN
   okure[0,alpha(mot[1])].occ := (okure[0,alpha(mot[1])].occ +1);
   FOR i := 1 TO (length(mot)-1) DO
   BEGIN
      //WRITELN(mot[i], mot[i+1]);
      okure[alpha(mot[i]),alpha(mot[i+1])].occ := ((okure[alpha(mot[i]),alpha(mot[i+1])].occ)+1);
   END;
   okure[alpha(mot[length(mot)]),0].occ := (okure[alpha(mot[length(mot)]),0].occ)+1;
   occurrence:= okure;
END; { occurrence }

(*
 ------------------------------------------------------------------------------------
 -- Fonction          : prob(tob:tableau):tableau
 -- Auteur            : LARREGLE <larregleth@eisti.eu>
 -- Date de creation  : Mon Dec 17 17:46:27 2018
 --
 -- But               : Calcule la cumulation des nombres en digramme, pour réaliser les probabilités
 -- Remarques         : Le cumule commence à 1 pour que 0 corresponde à une absence de l'occurrence lors de l'utilisation de la variable aléatoire, on ignorera ce résultat
 -- Pré conditions    : Préconditions
 -- Post conditions   : But
 ------------------------------------------------------------------------------------*)
FUNCTION prob(tob:tableau2D):tableau2D;
VAR
   m,p    : Integer ;
   cumule : Int64;
BEGIN
   FOR p := 0 TO N DO
   BEGIN
      cumule := 0;
      FOR m := 0 TO N DO
      BEGIN
         cumule := cumule + tob[p,m].occ; //Nombre d'occurrence totale dans une ligne
         IF (tob[p,m].occ <> 0) THEN
         BEGIN
            tob[p,m].prob := cumule;
         END
         ELSE
            tob[p,m].prob := 0;
      END;
      tob[p,N].occ := cumule; //Indice pour la variable aléatoire
   END;
   prob:= tob;
END; {prob}

(*
 ------------------------------------------------------------------------------------
 -- Fonction          : ChargelexiqueNrv
 -- Auteur            : LARREGLE <larregleth@eisti.eu>
 -- Date de creation  : Fri Dec 14 14:43:42 2018
 --
 -- But               : Charge le lexique et remplie le tableau qui collectera les occurrences
 -- Remarques         : Aucune
 -- Pré conditions    : Préconditions
 -- Post conditions   : But
 ------------------------------------------------------------------------------------*)
FUNCTION ChargelexiqueNrv(tab : tableau2D; filename : String) : tableau2D;
VAR
   ligne : Widestring ;
   fic   : Text;
BEGIN
   ligne :=  ' ' ;
   assign (fic, filename) ;
   RESET(fic);
   IF ( IOResult <> 0 )THEN
   BEGIN
      WRITELN('le fichier n existe pas');
   END
   ELSE
   BEGIN
      REPEAT
         READLN(fic, ligne) ;
         IF conforme(LowerCase(ligne)) THEN
         BEGIN
            //WRITELN(ligne);
            tab := occurrence(LowerCase(ligne),tab);
         END;
      UNTIL eof(fic);
      close(fic) ;
      tab := prob(tab);
   END;
   ChargelexiqueNrv := tab;
END; { ChargelexiqueNrv }

(*
 ------------------------------------------------------------------------------------
 -- Fonction          : creer():tableau
 -- Auteur            : LARREGLE <larregleth@eisti.eu>
 -- Date de creation  : Tue Dec 11 15:47:19 2018
 --
 -- But               : Créer le tableau où seront stockées les variables
 -- Remarques         : Aucune
 -- Pré conditions    : Préconditions
 -- Post conditions   : But
 ------------------------------------------------------------------------------------*)
FUNCTION creerdi():tableau2D;
VAR
   res     : tableau2D;
   i,j     : Integer;
BEGIN
   FOR i := 0 TO N DO
   BEGIN
      FOR j := 0 TO N DO
      BEGIN
         res[i,j].occ := 0;
         res[i,j].prob := 0;
      END;
   END;
   creerdi := res;
END; { creer }

(*
 ------------------------------------------------------------------------------------
 -- PROCEDURE         : affichestat(statis : tableau): tableau
 -- Auteur            : LARREGLE <larregleth@eisti.eu>
 -- Date de creation  : Tue Dec 11 15:04:48 2018
 --
 -- But               : Test pour voir les valeurs au final empilées en créant un tableau similaire à celui présenté au projet
 -- Remarques         : Aucune
 -- Pré conditions    : Préconditions
 -- Post conditions   : But
 ------------------------------------------------------------------------------------*)
FUNCTION affichestat(statis :tableau2D):tableau2D;
VAR
   k,l : Integer;
BEGIN
   FOR k := 0 TO N DO
   BEGIN
      FOR l := 0 TO N DO
      BEGIN
         WRITE(statis[k,l].occ);
         WRITE('  ');
      END;
      WRITELN();
   END;
   affichestat := statis;
END; { affichestat }

(*
 ------------------------------------------------------------------------------------
 -- Fonction          : TrouveLettreFin(tablo : tableau ; character : Widestring):word
 -- Auteur            : LARREGLE <larregleth@eisti.eu>
 -- Date de creation  : Wed Dec 19 10:27:40 2018
 --
 -- But               : Génère un nombre aléatoire qui va permettre de savoir sur quel lettre cela va tomber en prenant en compte le nombre d'occurrences et note l'indice de la colonne.
 -- Remarques         : Aucune
 -- Pré conditions    : Préconditions
 -- Post conditions   : But
 ------------------------------------------------------------------------------------*)
FUNCTION TrouveLettreFin(tablo : tableau2D; character : word): word;
VAR
   o : Integer;
   verite,cumule2  : Int64;
   res2     : word;
BEGIN
   //WRITELN('NextLetter');
   o := 0;
   cumule2 := tablo[alpha(character.maut[length(character.maut)]),N].occ;                   // Nombre d'occurrences maximale dans une ligne
   verite := random(cumule2);                                                               // Récupère un chiffre dans un intervalle défini par le nombre d'occurrences
   WHILE (tablo[alpha(character.maut[length(character.maut)]),o].prob <= verite) DO         // Tant que la probabilité d'une CASE est inférieure au nombre tiré
   BEGIN
      o := o +1;
   END;
   res2.ind := o;                                                                           // Récupère l'indice
   //   WRITELN(res2.maut);
   res2.maut := character.maut + chiffreToLettre(o);                                        // Ajoute la lettre obtenue
   TrouveLettreFin:= res2;
END; { TrouveLettreFin }

(*
 ------------------------------------------------------------------------------------
 -- Fonction          : creamots (tub : tableau ; number : Integer) : Widestring
 -- Auteur            : LARREGLE <larregleth@eisti.eu>
 -- Date de creation  : Wed Dec 19 09:11:51 2018
 --
 -- But               : Créer UN mot aléatoire
 -- Remarques         : Aucune
 -- Pré conditions    : Préconditions
 -- Post conditions   : But
 ------------------------------------------------------------------------------------*)
FUNCTION creamots(tub : tableau2D) : Widestring;
VAR
   temoin : Integer;
   res    : word;
   fini   : Integer;
BEGIN
   fini := 1;
   temoin := random(tub[0,N].occ);
   WHILE (tub[0,fini].prob <= temoin) DO
   BEGIN
      fini := fini + 1;
   END;
   res.maut := chiffreToLettre(fini); //Commence une lettre prise au hasard
   //WRITELN('First Letter');
   //WRITELN(res.maut);
   res.ind := fini;
   //WRITELN(res.ind);
   WHILE (res.ind <> 0) DO
   BEGIN
      //WRITELN('Je suis WHILE');
      //WRITELN(res.ind);
      res := TrouveLettreFin(tub,res); // Trouve la lettre suivante et récupère l'indice de la colonne
      //WRITELN(res.maut);
   END;
   creamots:= res.maut;
END; {creamots}
(*
 ------------------------------------------------------------------------------------
 -- PROCEDURE         : motlongspeciale(stat : tableau; qtnmots : Integer; longmot : Integer);
 -- Auteur            : LEFLOCH Thomas <leflochtho@eisti.eu>
 -- Date de creation  : Thu Jan 17 10:52:54 2019
 --
 -- But               : Permet de générer un mot d'une longueur définie
 -- Remarques         : Aucune
 -- Pré conditions    : longueur non nulle
 -- Post conditions   : Permet de générer un mot d'une longueur définie
 ------------------------------------------------------------------------------------*)
PROCEDURE motlongspeciale(stat : tableau2D; qtnmots : Integer; longmot : Integer);
VAR
   i,k :  Integer;
   supremot : WideString;
BEGIN
   FOR k := 1 TO qtnmots DO
   BEGIN
      i :=0;
      supremot := creamots(stat);
      WHILE ((length(supremot) <> longmot+1) AND (i < 10000)) DO
      BEGIN
         supremot := creamots(stat);
         i:= i+1;
         // WRITELN('je génère un nouveau mot');
      END;
      IF i = 10000 THEN
      BEGIN
         WRITELN('Longueur invalide, génération d''un mot de longueur automatique');
      END;
      WRITELN(supremot);
   END;
END; { motlongspeciale }
(*
 ------------------------------------------------------------------------------------
 -- PROCEDURE         : digrammezer
 -- Auteur            : LEFLOCH Thomas <leflochtho@eisti.eu>
 -- Date de creation  : Thu Jan 10 14:43:49 2019
 --
 -- But               : Execute toutes les fonctions en rapport avec le digramme
 -- Remarques         : Aucune
 -- Pré conditions    : nombre de mots et fichier renseigné -- Post conditions   : Execute toutes les fonctions en rapport avec le digramme
 ------------------------------------------------------------------------------------*)
PROCEDURE digrammezer(qtnmots : Integer ; longmot : Integer; namefile : String);
VAR
   stat            : tableau2D;
   j               : Integer;
   longueurdemande : Boolean;
BEGIN
   longueurdemande := longmot > 0;
   WRITELN('Génération d'' un mot avec la méthode des digrammes');
   stat := creerdi();
   stat := ChargelexiqueNrv(stat,namefile);
   //affichestat(stat); Permet d'afficher le tableau des stats complet.
   IF longueurdemande THEN
   BEGIN
      motlongspeciale(stat, qtnmots, longmot);
   END
   ELSE
   BEGIN
      FOR j := 1 TO qtnmots DO
      BEGIN
         WRITELN(creamots(stat));
      END;
   END;
END; { digrammezer }

/// PHRASES /// PHRASES //// PHRASES /// PHRASES /// PHRASES /// PHRASES /// PHRASES /// PHRASES /// PHRASES /// PHRASES /// PHRASES /// PHRASES /// PHRASES /// PHRASES /// PHRASES /// PHRASES /// PHRASES /// PHRASES ///

(*
 ------------------------------------------------------------------------------------
 -- Fonction          : ChoixSujet
 -- Auteur            : LEFLOCH Thomas <leflochtho@eisti.eu>
 -- Date de creation  : Wed Dec 19 08:38:44 2018
 --
 -- But               : Permet de choisir un sujet parmi la liste des pronoms ou appelle la liste les prénoms pour en choisir un.
 -- Remarques         : Aucune
 -- Pré conditions    : Aucune
 -- Post conditions   : Permet de choisir un sujet parmi la liste des pronoms ou appelle la liste des prénoms pour en choisir un.
 ------------------------------------------------------------------------------------*)
FUNCTION ChoixSujet(tableaunam : overtableau):sujet;
VAR
   pronomz : sujet;
   valeur,segment  : Integer;
BEGIN
   segment := Random(100)+1;
   IF segment < 51 THEN // Choisit un pronom ou un nom propre généré aléatoirement
   BEGIN
      valeur := Random(10)+1;
      pronomz.pronom := pronoms[valeur];
      pronomz.personne := valeur;
   END
   ELSE
   BEGIN
      pronomz.pronom := creamotri(tableaunam); // génère un nom propre
      pronomz.personne := 3;
   END;
   ChoixSujet:= pronomz;
END; { ChoixSujet }

(*
 ------------------------------------------------------------------------------------
 -- Fonction          : DeterminePersonne(Article : WideString):sujet
 -- Auteur            : LEFLOCH Thomas <leflochtho@eisti.eu>
 -- Date de creation  : Sat Jan 19 15:43:21 2019
 --
 -- But               : Permet de determiner la personne du groupe sujet pour procéder à la conjuguaison
 -- Remarques         : Aucune
 -- Pré conditions    : L'article doit être non vide.
 -- Post conditions   : Permet de determiner la personne du groupe sujet pour procéder à la conjuguaison
 ------------------------------------------------------------------------------------*)
FUNCTION DeterminePersonne(Article : WideString):sujet;
VAR
   res : sujet;
BEGIN
   res.personne := 3;
   IF ((Article[length(Article)-1] = 's') OR (Article[length(Article)-1] = 'x')) THEN
   BEGIN
      res.personne := 8; // 8 correspond à la troisième personne du pluriel
   END;
   res.pronom := Article;
   DeterminePersonne:= res;
END; { DeterminePersonne }

(*
 ------------------------------------------------------------------------------------
 -- Fonction          : Conjugateur(verbe : verbe):verbe
 -- Auteur            : LEFLOCH Thomas <leflochtho@eisti.eu>
 -- Date de creation  : Wed Dec 19 10:13:31 2018
 --
 -- But               : Permet de conjuguer un verbe en fonction de son groupe et de son sujet
 -- Remarques         : Aucune
 -- Pré conditions    : Verbe du groupe 1 ou 2.
 -- Post conditions   : Permet de conjuguer un verbe en fonction de son groupe et de son sujet
 ------------------------------------------------------------------------------------*)
FUNCTION Conjugateur(verbe : conjug; thesujet : sujet):WideString;
VAR
   conjugaverbe : WideString;
BEGIN
   IF verbe.premgroupe THEN
   BEGIN
      CASE thesujet.personne OF
        1,3,4,5 : conjugaverbe := verbe.verb + 'e';

        2       : conjugaverbe := verbe.verb + 'es';
        6       :  conjugaverbe := verbe.verb + 'ons';
        7       :  conjugaverbe := verbe.verb + 'ez';
        8,9 :  conjugaverbe := verbe.verb + 'ent';
        ELSE
           conjugaverbe := verbe.verb + 'er';
      END; { CASE1 }
   END
   ELSE
   BEGIN
      CASE thesujet.personne OF
        1,2   : conjugaverbe := verbe.verb + 'is';
        3,4,5 : conjugaverbe := verbe.verb + 'it';
        6     : conjugaverbe := verbe.verb + 'issons';
        7     : conjugaverbe := verbe.verb + 'issez';
        8,9 : conjugaverbe := verbe.verb + 'issent';
        ELSE
           conjugaverbe := verbe.verb +  'er';
      END; { CASE }
   END;
   Conjugateur:= conjugaverbe;
END; { Conjugateur }
(*
 ------------------------------------------------------------------------------------
 -- Fonction          : kelesttonsex
 -- Auteur            : LEFLOCH Thomas <leflochtho@eisti.eu>
 -- Date de creation  : Fri Dec 21 15:20:15 2018
 --
 -- But               : Determine le genre et le nombre du mot généré par digramme/trigramme.
 -- Remarques         : Aucune
 -- Pré conditions    : mot en entrée non vide
 -- Post conditions   : Determine le genre et le nombre du mot généré par digramme/trigramme.
 ------------------------------------------------------------------------------------*)
FUNCTION kelesttonsex(TheMot : WideString):Accord;
VAR
   eldonsexe   : Accord;
BEGIN
   eldonsexe.sexe := ((copy(TheMot,length(TheMot)-2,2) = 'es') OR (TheMot[length(TheMot)-1] = 'a'));
   //WRITELN(TheMot[length(TheMot)-1]);
   eldonsexe.qtn := ((TheMot[length(TheMot)-1] = 's')OR (copy(TheMot,(length(TheMot))-2,2) = 'es') OR (TheMot[length(TheMot)-1] = 'x'));
   kelesttonsex:= eldonsexe;
END; { kelesttonsex }
(*
 ------------------------------------------------------------------------------------
 -- Fonction          : Accordateur()
 -- Auteur            : LEFLOCH Thomas <leflochtho@eisti.eu>
 -- Date de creation  : Tue Jan 15 13:31:14 2019
 --
 -- But               : Permet d'accorder un adjectif avec le nom commun généré correspondant.
 -- Remarques         : Aucune
 -- Pré conditions    : Le mot doit avoir son genre et son nombre de prédéfini.
 -- Post conditions   : Permet d'accorder un adjectif avec le nom commun généré correspondant.
 ------------------------------------------------------------------------------------*)
FUNCTION Accordateur(Mot : WideString; GenreEtNombre : accord):WideString;

BEGIN
   IF GenreEtNombre.sexe THEN
   BEGIN
      IF NOT((Mot[length(Mot)] = ('e'))) THEN
      BEGIN
         Mot := Mot + 'e';
      END;
   END;
   IF GenreEtNombre.qtn THEN
   BEGIN
      IF Mot[length(Mot)] = 'u' THEN
      BEGIN
         Mot := Mot + 'x';
      END
      ELSE
      BEGIN
         Mot := Mot + 's'
      END;
   END;
   Accordateur:= Mot;
END; { Accordateur }
(*
 ------------------------------------------------------------------------------------
 -- Fonction          : GroupZer(TheVerb : WideString) : conjug
 -- Auteur            : LEFLOCH Thomas <leflochtho@eisti.eu>
 -- Date de creation  : Tue Jan 15 17:12:53 2019
 --
 -- But               : Permet de determiner le groupe d'un verbe et d'appeler la fonction qui le conjugue
 -- Remarques         : Aucune
 -- Pré conditions    : Aucune
 -- Post conditions   : Permet de determiner le groupe d'un verbe et d'appeler la fonction qui le conjugue
 ------------------------------------------------------------------------------------*)
FUNCTION GroupZer(TheVerb : WideString; TheSujet : sujet ) : WideString;
VAR
   VerbeDeter : conjug;
BEGIN
   VerbeDeter.premgroupe := copy(TheVerb,length(TheVerb)-2,3) = 'er'; // teste le groupe
   DELETE(TheVerb,length(TheVerb)-2,2); // supprime l'infinitif
   VerbeDeter.verb := TheVerb;
   TheVerb := Conjugateur(VerbeDeter,TheSujet); // conjugue le verbe
   GroupZer := TheVerb;
END;
(*
 ------------------------------------------------------------------------------------
 -- Fonction          : Majuscule(TheSujet : WideString): Widestring;
 -- Auteur            : LEFLOCH Thomas <leflochtho@eisti.eu>
 -- Date de creation  : Tue Jan 15 19:00:42 2019
 --
 -- But               : But
 -- Remarques         : Aucune
 -- Pré conditions    : Préconditions
 -- Post conditions   : But
 ------------------------------------------------------------------------------------*)
FUNCTION Majuscule(TheSujet : WideString): Widestring;
VAR
   SujetMaj :  Widestring;
BEGIN
   IF (length(TheSujet) >= 2) THEN
   BEGIN
      SujetMaj := (UpperCase(copy(TheSujet,1,1)) + copy(TheSujet,2,length(TheSujet)));
   END
   ELSE
   BEGIN
      SujetMaj := UpperCase(TheSujet);
   END;
   Majuscule:= SujetMaj;
END; { Majuscule}

(*
 ------------------------------------------------------------------------------------
 -- PROCEDURE         : AffichePhraseBonusZer
 -- Auteur            : LEFLOCH Thomas <leflochtho@eisti.eu>
 -- Date de creation  : Wed Jan 16 18:47:35 2019
 --
 -- But               : Permet d'afficher une phrase sujet verbe, sujet verbe + complément simple , sujet verbe + complément long
 -- Remarques         : Segmentation Fault si on essaye de générer le dictionnaire des adverbes (dû à un manque de mémoire vive allouée)
 -- Pré conditions    : Mots Générés
 -- Post conditions   : Permet d'afficher une phrase sujet + verbe, sujet verbe + complément simple , sujet verbe + complément long
 ------------------------------------------------------------------------------------*)
PROCEDURE AffichePhraseBonusZer(TheMot : WideString ; TheAdj : WideString; TheSujet : sujet; TheVerb : WideString; TheArt : WideString;GenreEtNombre : Accord); //TheAdv : WideString);
VAR
   r :  Integer;
BEGIN
   r := Random(20);
   // IF ((r <= 30) AND (r >= 20)) THEN
   // BEGIN
   // WRITELN('Génération d''une phrase bonus de niveau 3');
   // WRITELN((Majuscule(TheSujet.pronom)),' ',(GroupZer(TheVerb,TheSujet))' ',TheAdv,' ',TheArt,' ',(Accordateur(TheMot,GenreEtNombre)),' ', (Accordateur(TheAdj,GenreEtNombre)),'.');
   // END
   // ELSE
BEGIN
   IF ((r < 20) AND (r >= 10)) THEN
   BEGIN
      WRITELN('Génération d''une phrase bonus de niveau 2');
      WRITELN((Majuscule(TheSujet.pronom)),' ',(GroupZer(TheVerb,TheSujet)), ' ', TheArt, ' ',(Accordateur(TheMot,GenreEtNombre)),' ',(Accordateur(TheAdj,GenreEtNombre)),'.');
   END
   ELSE
   BEGIN
      WRITELN('Génération d''une phrase bonus de niveau 1');
      WRITELN((Majuscule(TheSujet.pronom)), ' ', (GroupZer(TheVerb,TheSujet)), ' ', TheArt, ' ',(Accordateur(TheMot,GenreEtNombre)),'.');
   END;
END;
END; {AffichePhraseBonusZer}
(*
 ------------------------------------------------------------------------------------
 -- PROCEDURE         : AffichePhraseStandardZer
 -- Auteur            : LEFLOCH Thomas <leflochtho@eisti.eu>
 -- Date de creation  : Sat Jan 19 12:21:32 2019
 --
 -- But               : permet de générer des phrases comme demandé dans l'énoncé
 -- Remarques         : Aucune
 -- Pré conditions    : Préconditions
 -- Post conditions   : permet de générer des phrases comme demandé dans l'énoncé
 ------------------------------------------------------------------------------------*)
PROCEDURE AffichePhraseStandardZer(TheMot : WideString ; TheAdj : WideString; TheSujet : sujet; TheVerb : WideString;GenreEtNombre : Accord);// TheAdv : WideString);
VAR
   r :Integer;
BEGIN
   r := Random(20);
     WRITELN(r);
   // IF ((r <= 30) AND (r >= 20)) THEN
   // BEGIN
   // WRITELN(Majuscule(TheSujet.pronom),' ',Accordateur(TheMot,GenreEtNombre),' ',GroupZer(TheVerb,TheSujet),' ',TheAdv,' ',Accordateur(TheAdj, GenreEtNombre),'.');
   // WRITELN('Génération d''une phrase standard de niveau 3');
   // END
   // ELSE
BEGIN
   IF ((r < 20) AND (r >= 10)) THEN
   BEGIN
      WRITELN(Majuscule(TheSujet.pronom),' ',Accordateur(TheMot,GenreEtNombre),' ',GroupZer(TheVerb,TheSujet),' ',Accordateur(TheAdj,GenreEtNombre),'.');
      WRITELN('Génération d''une phrase standard de niveau 2');
   END
   ELSE
   BEGIN
      WRITELN(Majuscule(TheSujet.pronom),' ',Accordateur(TheMot,GenreEtNombre),' ',GroupZer(TheVerb,TheSujet),'.');
      WRITELN('Génération d''une phrase standard de niveau 1');
   END;
END;
END; { SentenceBuilderZer }
(*
 ------------------------------------------------------------------------------------
 -- PROCEDURE         : SentenceBuilderZer(qtnPhrases : Integer; elfamosofichier : String)
 -- Auteur            : LEFLOCH Thomas <leflochtho@eisti.eu>
 -- Date de creation  : Mon Jan 14 11:04:37 2019
 --
 -- But               : Permet de construire une phrase de TYPE sujet + verbe + complément
 -- Remarques         : Aucune
 -- Pré conditions    : Fichier en entrée + dictionnaires de verbes, noms et adjectifs présents dans le dossier d'execution du programme
 -- Post conditions   : Permet de construire une phrase de TYPE sujet + verbe + complément
 ------------------------------------------------------------------------------------*)
PROCEDURE SentenceBuilderZer(qtnPhrases : Integer; elfamosofichier : String; bonus : Integer);
VAR
   TheSujetBonus, TheSujetNormal                              : sujet;
   TheVerb, TheMot, TheArt, TheAdj                            : WideString; //,TheAdv
   tableautri, tableauart, tableauver, tableaunam, tableauadj : overtableau; //,tableauadv
   GenreEtNombre                                              : Accord;
   i                                                          : Integer;
BEGIN
   tableautri := creertri();
   tableauart := creertri();
   tableauver := creertri(); // initialise les tableau de chaque partie de la phrase
   tableaunam := creertri();
   tableauadj := creertri();
   //tableauadv := creertri();
   tableautri := (ChargelexiqueNrvtri(tableautri, elfamosofichier));
   tableauver := (ChargelexiqueNrvtri(tableauver, lexiqueverbe));
   tableaunam := (ChargelexiqueNrvtri(tableaunam, lexiquenomspropres));
   tableauart := (ChargelexiqueNrvtri(tableauart, lexiquearticles)); // Charge les lexiques de chaque dictionnaires
   tableauadj := (ChargelexiqueNrvtri(tableauadj, lexiqueadjectif));
   // tableauadv := (ChargelexiqueNrvtri(tableauadv, lexiqueadverbes));
   FOR i := 1 TO qtnPhrases DO
   BEGIN
      TheMot := creamotri(tableautri); // génère un mot aléatoire.
      TheArt := creamotri(tableauart); // Génère un article
      GenreEtNombre := kelesttonsex(TheArt); // défini le genre et le nombre de l'article généré
      TheSujetBonus := ChoixSujet(tableaunam); // choisit un pronom ou génère un nom aléatoirement
      TheSujetNormal := DeterminePersonne(TheArt);
      TheVerb := creamotri(tableauver); // Génère un verbe
      TheAdj := creamotri(tableauadj); // Génère un adjectif
     // TheAdv := creamotri(tableauadv);  // Génère un adverbe
      IF bonus = 3 THEN
      BEGIN
         AffichePhraseStandardZer(TheMot,TheAdj,TheSujetNormal,TheVerb,GenreEtNombre); //,TheAdv);
      END
      ELSE
      BEGIN
         AffichePhraseBonusZer(TheMot,TheAdj,TheSujetBonus,TheVerb,TheArt,GenreEtNombre);//,TheAdv);
      END;
   END;
END; { SentenceBuilderZer }

/// MENU /// MENU /// MENU /// MENU /// MENU /// MENU /// MENU /// MENU /// MENU /// MENU /// MENU /// MENU /// MENU /// MENU /// MENU /// MENU /// MENU /// MENU /// MENU /// MENU /// MENU /// MENU /// MENU /// MENU ///

(*
 ------------------------------------------------------------------------------------
 -- PROCEDURE         : showHelp
 -- Auteur            : LEFLOCH Thomas <leflochtho@eisti.eu>
 -- Date de creation  : Fri Dec 14 15:03:21 2018
 --
 -- But               : Permet d'afficher l'aide
 -- Remarques         : si le fichier readme n'est pas dans le dossier d'execution du programme, il retourne une erreur
 -- Pré conditions    : Aucune
 -- Post conditions   : Permet d'afficher l'aide
 ------------------------------------------------------------------------------------*)
PROCEDURE showHelp;
VAR
   fic   : Text;
   ligne : String;
BEGIN
   ligne := '';
   assign(fic, fichierdaide);
   RESET(fic);
   IF (IOResult <> 0) THEN
   BEGIN
      WRITELN('Fichier README introuvable.');
   END
   ELSE
   BEGIN
      REPEAT
         READLN(fic,ligne); // Affiche tout le fichier readme.txt
         WRITELN(ligne);
      UNTIL(eof(fic));
      CLOSE(fic);
   END;
END; { showHelp }
(*
 ------------------------------------------------------------------------------------
 -- Fonction          : premierArg(argument :String;parametre : param):param
 -- Auteur            : LEFLOCH Thomas <leflochtho@eisti.eu>
 -- Date de creation  : Wed Jan  9 09:53:16 2019
 --
 -- But               : Permet d'assigner une valeur en fonction de la méthode séléctionnée
 -- Remarques         : Aucune
 -- Pré conditions    : paramStr(i) non vide
 -- Post conditions   : Permet d'assigner une valeur en fonction de la méthode séléctionnée
 ------------------------------------------------------------------------------------*)
FUNCTION premierArg(argument : String; parametre : arg  ):arg ;
BEGIN
   IF argument = '-a' THEN
   BEGIN
      parametre.methode := 1;
   END;
   IF argument = '-d' THEN
   BEGIN
      parametre.methode := 2;
   END;
   IF argument = '-t' THEN
   BEGIN
      parametre.methode := 4;
   END;
   IF argument = '-p' THEN
   BEGIN
      parametre.methode := 3;
   END;
   IF argument = '-ps' THEN
   BEGIN
      parametre.methode := 5;
   END;
   IF argument = '-h' THEN
   BEGIN
      parametre.methode := 6;
   END;
   premierArg:= parametre;
END; { premierArg }
(*
 ------------------------------------------------------------------------------------
 -- Fonction          : secondArg
 -- Auteur            : LEFLOCH Thomas <leflochtho@eisti.eu>
 -- Date de creation  : Wed Jan  9 09:56:49 2019
 --
 -- But               : Permet de trouver si oui ou non il y a d'autres arguments
 -- Remarques         : Aucune
 -- Pré conditions    : ParamStr() <> -h,-t,-p,-d,-a
 -- Post conditions   : Permet de trouver si oui ou non il y a d'autres arguments
 ------------------------------------------------------------------------------------*)
FUNCTION secondArg(argument : String; parametre : arg  ;  i : Integer):arg;
BEGIN
   IF ((argument = '-n') AND (CharINSet((paramStr(i+1)[1]),['0'..'9'])))  THEN
   BEGIN
      parametre.nombre := StrToInt(paramStr(i+1));
   END;
   IF ((argument = '-s') AND (CharInSet((paramStr(i+1)[1]),['0'..'9']))) THEN
   BEGIN
      parametre.longueur := StrToInt(paramStr(i+1));
   END;
   //IF (NOT(CharInSet((argument[1]),['0'..'9'])) AND (argument <> '-n') AND (argument <> '-s')) THEN
   //BEGIN
   //parametre.fichier := paramStr(i);
   //END;
   secondArg:= parametre;
END; { secondArg }

(*
 ------------------------------------------------------------------------------------
 -- Fonction          : lireParam():String
 -- Auteur            : LEFLOCH Thomas <leflochtho@eisti.eu>
 -- Date de creation  : Tue Dec 11 15:56:40 2018
 --
 -- But               : Permet de récupérer les paramètres
 -- Remarques         : Aucune
 -- Pré conditions    : Paramcount > 1
 -- Post conditions   : Permet de récupérer les paramètres
 ------------------------------------------------------------------------------------*)
FUNCTION lireParam():arg;
VAR
   param       : arg;
   i           : Integer;
BEGIN
   i := 0;
   param.nombre := 100;
   param.longueur := 0;
   WHILE i <= paramcount DO
   BEGIN
      //WRITELN(paramStr(i));
      IF ((paramStr(i) = '-t') OR (paramStr(i) ='-h') OR (paramStr(i) = '-d') OR (paramStr(i) ='-a') OR (paramStr(i) = '-p') OR (paramStr(i) = '-ps')) THEN
      BEGIN
         param := premierarg(paramStr(i),param); // appelle la fonction qui lit la valeur de l'argument et l'assigne à une certaine fonction
      END
      ELSE
         IF ((paramStr(i) = '-n') OR (paramStr(i) ='-s')) THEN
         BEGIN
            param := secondarg(paramStr(i),param,i); // appelle une fonction qui trouve la valeur de -n nb et -s nb si elles existent.
         END;
      i := i+1;
      param.fichier := paramStr(paramcount);
   END;
   lireParam := param
END; { lireParam }
(*
 ------------------------------------------------------------------------------------
 -- PROCEDURE         : startProg(parametres : param)
 -- Auteur            : LEFLOCH Thomas <leflochtho@eisti.eu>
 -- Date de creation  : Wed Jan  9 10:20:47 2019
 --
 -- But               : Permet de démarrer la bonne fonction selon les paramètres selectionnés.
 -- Remarques         : valeur par defaut donne
 -- Pré conditions    : parametres passés au récupérateur d'arguments au préalable.
 -- Post conditions   : Permet de démarrer la bonne fonction selon les paramètres selectionnés.
 ------------------------------------------------------------------------------------*)
PROCEDURE startProg(parametre : arg);
BEGIN
   CASE parametre.methode OF
     1 :
        BEGIN
           AleaMot(parametre.longueur,parametre.nombre);
        END;
     2 :
        BEGIN
           IF (Copy(parametre.fichier,(length(parametre.fichier)-3), 4)) = '.txt' THEN
           BEGIN
              digrammezer(parametre.nombre,parametre.longueur,parametre.fichier);
           END
           ELSE
           BEGIN
              ShowHelp();
           END;
        END;
     3,5 :
   BEGIN
      IF (Copy(parametre.fichier,(length(parametre.fichier)-3), 4)) = '.txt' THEN
      BEGIN
         SentenceBuilderZer(parametre.nombre,parametre.fichier,parametre.methode);
      END
      ELSE
      BEGIN
         ShowHelp();
      END;
   END;
     4 :
        BEGIN
           IF (Copy(parametre.fichier,(length(parametre.fichier)-3), 4)) = '.txt' THEN
           BEGIN
              TrigrammeZer(parametre.nombre,parametre.longueur,parametre.fichier);
           END
           ELSE
           BEGIN
              ShowHelp();
           END;
        END;
     ELSE
        showHelp();
   END;
END; { startProg }

{*Début du programme principal*}
VAR
   parametres : arg;
BEGIN
   IF ((paramCount > 0) AND (paramcount <= 6)) THEN
   BEGIN
      Randomize();
      parametres := lireParam(); //lit les paramètres et envoie les données à la fonction respective;
      //WRITELN(parametres.methode);
      //WRITELN(parametres.nombre);
      //WRITELN(parametres.longueur);
      //WRITELN(parametres.fichier);
      startProg(parametres);
   END
   ELSE
   BEGIN
      showHelp();
   END;
END.
