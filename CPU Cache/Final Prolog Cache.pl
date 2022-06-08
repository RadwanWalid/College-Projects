                       /*  Convert Binary to Decimal  */

binToDecHelper(0,_,0).
binToDecHelper(Bin,Acc,Dec):-
	Bin > 0 ,
	Acc1 is Acc+1,
	Bin1 is Bin//10,
	binToDecHelper(Bin1,Acc1,Dec1),
	Dec is Dec1 + ((2**Acc)*(Bin mod 2)).
convertBinToDec(Bin,Dec):-
	binToDecHelper(Bin,0,Dec).

                          /*  Replace Ith Item  */

replaceIthItem(Item,[_|T],0,[Item|T]).
replaceIthItem(Item,[H|T],I,[H|T1]):-
	I>0,
	I1 is I-1,
	replaceIthItem(Item,T,I1,T1).

                          /*  Split Every Nth */

splitEvery(N,List,Res):-
  helper(N,1,[],[],List,Res).
helper(_,_,Acc,[],[],Acc).
helper(_,_,Acc,L,[],Res):-
  length(L,X) ,
  X > 0 ,
  append(Acc,[L],Res).
helper(N,C,Acc,Acc2,[H|T],Res):-
  M is C mod N ,
  M > 0 ,
  C1 is C+1,
  append(Acc2,[H],Acc2new),
  helper(N,C1,Acc,Acc2new,T,Res).
helper(N,C,Acc,Acc2,[H|T],Res):-
  M is C mod N ,
  M = 0 ,
  C1 is C+1,
  append(Acc2,[H],Acc2new),
  append(Acc,[Acc2new],Accnew),
  helper(N,C1,Accnew,[],T,Res).


                                /*  Log  */

logBase2(1,0).
logBase2(Num,Res):-
	Num > 0 ,
	Num1 is Num//2,
	logBase2(Num1,Res1),
	Res is Res1 + 1 .

                            /*  Fill Zeros  */

fillZeros(X,0,X).
fillZeros(S,N,R):-
	N>0,
	N1 is N-1,
	string_concat(0,S,S3),
	fillZeros(S3,N1,R).

				          /*  getNumBits  */

getNumBits(_,fullyAssoc,_,0).
getNumBits(N,setAssoc,_,BitsNum):-
	logBase2(N,BitsNum).

getNumBits(_,directMap,Cache,BitsNum):-
	length(Cache,N),
	logBase2(N,BitsNum).
	
                        /* Get Data From Cache */
						
getDataFromCache(StringAddress,Cache,Data,0,directMap,BitsNum):-
	atom_number(StringAddress,Bin),
	convertAddress(Bin,BitsNum,Tag,Idx,directMap),
	convertBinToDec(Idx,Index),
	nth0(Index,Cache,item(tag(TagCache),data(DataCache),1,_)),
	atom_number(TagCache,TagNum),
	TagNum == Tag,
	Data = DataCache.


getDataFromCache(StringAddress,Cache,Data,HopsNum,fullyAssoc,_):-
    getDataFromCacheHelper(StringAddress,Cache,Data,HopsNum,fullyAssoc,_,0).

getDataFromCacheHelper(StringAddress,[item(tag(H),_,_,_)|T],Data,HopsNum,fullyAssoc,_,Place):-
    H \== StringAddress,
    Place1 is Place +1,
    getDataFromCacheHelper(StringAddress,T,Data,HopsNum,fullyAssoc,_,Place1).

getDataFromCacheHelper(StringAddress,[item(tag(StringAddress),data(Data),1,_)|_],Data,Place,fullyAssoc,_,Place).

	
getDataFromCache(StringAddress,Cache,Data,HopsNum,setAssoc,SetsNum):-
	atom_number(StringAddress,BinAddress),
	convertAddress(BinAddress,SetsNum,Tag,Idx,setAssoc) ,
	length(Cache,CacheLength) ,
	SetLength is CacheLength// SetsNum ,
	splitEvery(SetLength , Cache ,SetList) ,
	convertBinToDec(Idx,DecIdx),
	getSet(SetList,DecIdx,Set),
	getDataFromSet(Set,Tag,Data,0,HopsNum).

                         /* Helper Predicates */

getSet([H|T],0,H).
getSet([_|T],Idx,Set):-
	Idx > 0 ,
	Idx1 is Idx - 1 ,
	getSet(T,Idx1,Set).

getDataFromSet([item(tag(AtomTag),data(Data),1,_)|T],Tag,Data,HopsNum,HopsNum):-
	atom_number(AtomTag,Tag).
getDataFromSet([item(_,_,0,_)|T],Tag,Data,HopsCount,HopsNum) :-
	HopsCount1 is HopsCount + 1,
	getDataFromSet(T,Tag,Data,HopsCount1,HopsNum).
getDataFromSet([item(tag(AtomTag),data(Data),Valid,_)|T],Tag,Data,HopsCount,HopsNum) :-
	atom_number(AtomTag,ItemTag),
	ItemTag \= Tag ,
	HopsCount1 is HopsCount + 1,
	getDataFromSet(T,Tag,Data,HopsCount1,HopsNum).

                         /* Convert Address */
						 
convertAddress(Bin,BitsNum,Tag,Idx,directMap):-
	Idx is Bin mod (10**BitsNum),
	Tag is Bin//(10**BitsNum).
	
convertAddress(Tag,_,Tag,_,fullyAssoc).
convertAddress(Bin,_,Bin,_,fullyAssoc):-
	false.

convertAddress(Bin,SetsNum,Tag,Idx,setAssoc):-
	getNumBits(SetsNum,setAssoc,0,BitsNum),
	Tag is Bin // (10**BitsNum) ,
	Idx is Bin - Tag* (10**BitsNum).
	
						 /* Replace In Cache */
						
replaceInCache(Tag,Idx,Mem,OldCache,NewCache,ItemData,directMap,_):-
	dataRetrieval(Tag,Idx,Mem,ItemData,directMap),
	convertBinToDec(Idx,Index),
	string_length(Tag,L),
	N is 4-L,
	fillZeros(Tag,N,NewTag),
	replaceIthItem(item(tag(NewTag),data(ItemData),1,0),OldCache,Index,NewCache).

replaceInCache(Tag,Idx,Mem,OldCache,NewCache,ItemData,fullyAssoc,_):-
	dataRetrieval(Tag,Idx,Mem,ItemData,fullyAssoc),
	string_length(Tag,L),
	N is 6 - L,
	fillZeros(Tag,N,NewTag),
	(  (allValid(OldCache),
	    oldestItem(OldCache,Oldest),
	    nth0(Index,OldCache,Oldest),
	    incrementOrder(OldCache,OldCacheInc),
	    replaceIthItem(item(tag(NewTag),data(ItemData),1,0),OldCacheInc,Index,NewCache) );
	( firstError(OldCache,ErrorItem),
	nth0(Index,OldCache,ErrorItem),
	incrementOrder(OldCache,OldCacheInc),
	replaceIthItem(item(tag(NewTag),data(ItemData),1,0),OldCacheInc,Index,NewCache) ) ).
	
replaceInCache(Tag,Idx,Mem,OldCache,NewCache,ItemData,setAssoc,SetsNum):- 
	dataRetrieval(Tag,Idx,Mem,ItemData,setAssoc),
	length(OldCache,L),
	Split is L//SetsNum,
	splitEvery(Split,OldCache,OldCacheSet),
	nth0(Idx,OldCacheSet,Set),
	incrementOrder(Set,SetInc),
	string_length(Tag,TagL),
	N is 5-TagL,
	fillZeros(Tag,N,NewTag),
	((allValid(Set),
	oldestItem(Set,OldestItem),
	nth0(IndexO,Set,OldestItem),
	replaceIthItem(item(tag(NewTag),data(ItemData),1,0),SetInc,IndexO,NewSet));
	(\+allValid(Set),
	firstError(Set,FirstError),
	nth0(IndexE,Set,FirstError),
	replaceIthItem(item(tag(NewTag),data(ItemData),1,0),SetInc,IndexE,NewSet))),
	replaceIthItem(NewSet,OldCacheSet,Idx,NewCacheSet),
	flatten(NewCacheSet,NewCache).
	
							/* Helper Predicates */
	
allValid([]).
allValid([item(tag(_),data(_),1,_)|T]):- allValid(T).

firstError([item(tag(Tag),data(Data),0,Order)|_],item(tag(Tag),data(Data),0,Order)).
firstError([item(tag(_),data(_),1,_)|T],Item):-
	firstError(T,Item).

oldestItem([OldestItem],OldestItem).
oldestItem([item(tag(Tag),data(Data),ValidBit,Order),item(tag(_),data(_),_,Order1)|T],OldestItem):-
	maximum(Order,Order1,Order),
	oldestItem([item(tag(Tag),data(Data),ValidBit,Order)|T],OldestItem).
oldestItem([item(tag(_),data(_),_,Order),item(tag(Tag1),data(Data1),ValidBit1,Order1)|T],OldestItem):-
	maximum(Order,Order1,Order1),
	oldestItem([item(tag(Tag1),data(Data1),ValidBit1,Order1)|T],OldestItem).

incrementOrder([],[]).
incrementOrder([item(tag(Tag),data(Data),1,Order)|T],[item(tag(Tag),data(Data),1,Order1)|L]):-
	Order1 is Order + 1,
	incrementOrder(T,L).
incrementOrder([item(tag(Tag),data(Data),0,Order)|T],[item(tag(Tag),data(Data),0,Order)|L]):-
	incrementOrder(T,L).

maximum(A,B,A):- A >= B.
maximum(A,B,B):- A < B.

                           /* Data Retrieval */

dataRetrieval(Tag,Idx,Mem,ItemData,directMap):-
	string_length(Idx,IdxN),
	Fill is 2-IdxN,
	fillZeros(Idx,Fill,NewIdx),
	string_concat(Tag,NewIdx,Loc),
	atom_number(Loc,Add),
	convertBinToDec(Add,DecAdd),
	nth0(DecAdd,Mem,ItemData).	

dataRetrieval(Tag,_,Mem,ItemData,fullyAssoc):-
	convertBinToDec(Tag,DecAdd),
	nth0(DecAdd,Mem,ItemData).

dataRetrieval(Tag,Idx,Mem,ItemData,setAssoc):-
	string_concat(Tag,Idx,Address),
	atom_number(Address,Index),
	convertBinToDec(Index,I),
	nth0(I,Mem,ItemData).

 							  /*  Get Data  */
							 
getData(StringAddress,OldCache,Mem,NewCache,Data,HopsNum,Type,BitsNum,hit):-
	getDataFromCache(StringAddress,OldCache,Data,HopsNum,Type,BitsNum),
	NewCache = OldCache.
getData(StringAddress,OldCache,Mem,NewCache,Data,HopsNum,Type,BitsNum,miss):-
	\+getDataFromCache(StringAddress,OldCache,Data,HopsNum,Type,BitsNum),
	atom_number(StringAddress,Address),
	convertAddress(Address,BitsNum,Tag,Idx,Type),
	replaceInCache(Tag,Idx,Mem,OldCache,NewCache,Data,Type,BitsNum).

					       /* 	Run Program   */

runProgram([],OldCache,_,OldCache,[],[],Type,_).
runProgram([Address|AdressList],OldCache,Mem,FinalCache,[Data|OutputDataList],[Status|StatusList],Type,NumOfSets):-
	getNumBits(NumOfSets,Type,OldCache,BitsNum),
	(Type = setAssoc, Num = NumOfSets; Type \= setAssoc, Num = BitsNum),
	getData(Address,OldCache,Mem,NewCache,Data,HopsNum,Type,Num,Status),
	runProgram(AdressList,NewCache,Mem,FinalCache,OutputDataList,StatusList,Type,NumOfSets).