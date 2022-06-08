import Data.Foldable
data Item a = It Tag (Data a) Bool Int | NotPresent deriving (Show, Eq)
data Tag = T Int deriving (Show, Eq)
data Data a = D a deriving (Show, Eq)
data Output a = Out (a, Int) | NoOutput deriving (Show, Eq)

								             -- General Predicates --

convertBinToDec :: Integral a => a -> a
convertBinToDec 0 = 0
convertBinToDec x = x `mod` 10 + 2 * convertBinToDec (x `div` 10)

replaceIthItem :: (Eq a, Num a) => t -> [t] -> a -> [t]
replaceIthItem a (x:xs) 0 = a:xs
replaceIthItem a (x:xs) i = [x] ++ replaceIthItem a xs (i-1)
convertStringToInt x = (read :: String -> Int) x

--logBase2 :: Floating a => a -> a
logBase2   1 = 0
logBase2 x = 1 + logBase2 (div x 2)

splitEvery a (x:xs) = splitEveryHelper a (x:xs) [] []
splitEveryHelper a [] [] acc2 = acc2
splitEveryHelper a [] acc acc2 = acc2 ++ [acc]
splitEveryHelper a (x:xs) acc acc2
    | length acc == a = splitEveryHelper a (x:xs) [] (acc2++[acc])
    | otherwise = splitEveryHelper a xs (acc++[x]) acc2

fillZeros x 0 = x
fillZeros x a = fillZeros ("0" ++ x) (a-1)

--getNumBits :: (Floating a1, Integral a, RealFrac a1, Foldable t) => a1 -> [Char] -> t a2 -> a
getNumBits a "fullyAssoc" l = 0
getNumBits a "setAssoc" l = logBase2  a
getNumBits a  "directMap" l = logBase2 (length l)


                                              --Get Data Form Cache--


getDataFromCache stringAddress cache "directMap" bitsNum = getDataFromCacheHelperDirect (convertAddress (convertStringToInt stringAddress) bitsNum "directMap") cache

--getDataFromCache :: (Integral b, Eq a) => [Char] -> [Item a] -> [Char] -> b -> Output a
getDataFromCache stringAddress cache "fullyAssoc" _ = getDataFromCacheHelper(convertStringToInt stringAddress) cache  "fullyAssoc" 0

getDataFromCache stringAddress cache "setAssoc" bitsNum =
    getDataFromCacheHelperSetAssoc (convertAddress (convertStringToInt stringAddress) bitsNum "setAssoc") (splitEvery (length (cache) `div` (2^bitsNum)) cache)

getDataFromCacheHelperDirect (tag , binIndex) cache = getDataFromCacheHelperDirect2 (cache!!(convertBinToDec binIndex)) tag
getDataFromCacheHelperDirect2 (It (T tag) (D itemData) valid order) reqTag 
    | (reqTag == tag && valid) = Out (itemData,0)
    | otherwise =  NoOutput

getDataFromCacheHelper _ [] "fullyAssoc" _= NoOutput
getDataFromCacheHelper address ((It (T itemtag) (D itemdata) valid order):xs) "fullyAssoc" hopsNum
	|(address == itemtag && valid) = Out (itemdata , hopsNum)
	|otherwise = getDataFromCacheHelper address xs "fullyAssoc" (hopsNum+1)

getDataFromCacheHelperSetAssoc (tag , index) setlist = getDataFromCacheHelper2 (setlist!!(convertBinToDec index)) tag 0

getDataFromCacheHelper2 [] tag hopsNum = NoOutput
getDataFromCacheHelper2 (It (T itemtag) (D itemdata) valid order:xs) tag hopsNum 
    | (tag == itemtag  && valid)= Out (itemdata , hopsNum)
    | otherwise = getDataFromCacheHelper2 xs tag (hopsNum+1)
	
	
                                              -- Convert Address --


convertAddress tag bitsNum "directMap" = (tag `div` (10^bitsNum),tag `mod` (10^bitsNum))

--convertAddress :: (Integral b1, Integral b2) => b1 -> b2 -> p -> (b1, b1)
convertAddress binAddress bitsNum "fullyAssoc" = (binAddress,bitsNum)

--convertAddress  :: (Integral b1, Integral b2) => b1 -> b2 -> p -> (b1, b1)
convertAddress binAddress bitsNum "setAssoc" = (binAddress `div` 10^bitsNum,binAddress `mod` 10^bitsNum)


                                              -- Replace In Cache --


replaceInCache tag idx memory oldCache "directMap" _ = (dataRetrieval tag idx memory "directMap",
														      replaceIthItem (It (T tag) (D (dataRetrieval tag idx memory "directMap")) True 0) oldCache (convertBinToDec idx))
replaceInCache tag idx memory oldCache "fullyAssoc" _ = (dataRetrieval tag idx memory "fullyAssoc",
														       if allValid oldCache == True then (replaceIthItem (It (T tag) (D (dataRetrieval tag idx memory "fullyAssoc")) True 0) (incrementCache oldCache) (oldestItem oldCache)) 
														       else (replaceIthItem(It (T tag) (D (dataRetrieval tag idx memory "fullyAssoc")) True 0) (incrementCache oldCache) (firstError oldCache)))
replaceInCache tag idx memory oldCache "setAssoc" bitsNum = (dataRetrieval tag idx memory "setAssoc",
															 flatten (replaceIthItem (replaceInSet (It (T tag) (D (dataRetrieval tag idx memory "setAssoc")) True 0) (getSet oldCache bitsNum (convertBinToDec idx))) (splitEvery (power 2 bitsNum) oldCache) (convertBinToDec idx)))


		                                      -- Data Retrieval --	

											  
dataRetrieval tag idx memory "directMap" = (memory !! convertBinToDec(newIndex tag idx))
dataRetrieval tag idx memory "fullyAssoc" = (memory !! (convertBinToDec tag))
dataRetrieval tag idx memory "setAssoc" = memory !! (convertBinToDec (atomNumber ((show tag)++(show idx))))


                                                 -- Helpers --


atomNumber str = read str :: Int

numLength 0 = 1
numLength x | (mod x 10) == x = numLength (x `div` 10) 
			| otherwise = 1 + numLength (x `div` 10) 

newIndex tag idx = atomNumber ((show tag)++fillZeros (show idx) (2 - (numLength idx)))  

allValid [] = True
allValid ((It _ _ validBit _):xs) | (validBit == False) = False
								  | otherwise = (allValid xs)
 
oldestItem	cache = (oldestItemHelper cache 0) 
oldestItemHelper [(It _ _ _ order)] i = i
oldestItemHelper ((It (T tag1) (D data1) validBit1 order1):(It (T tag2) (D data2) validBit2 order2):xs) i | order1 > order2 = (oldestItemHelper ((It (T tag1) (D data1) validBit1 order1):xs) i)
																								          | otherwise = (oldestItemHelper ((It (T tag2) (D data2) validBit2 order2):xs) (i+1))
 
firstError memory = (firstErrorHelper memory 0)
firstErrorHelper [] i = error "All Valid"																								  
firstErrorHelper ((It _ _ validBit _):xs) i | 	validBit == False = i																							  
											| otherwise = (firstErrorHelper xs (i+1))													  

incrementCache [] = []
incrementCache ((It (T tag) (D itemdata) validBit order):xs) | validBit == True = (It (T tag) (D itemdata) validBit (order+1)):(incrementCache xs)
															 | otherwise = (It (T tag) (D itemdata) validBit (order)):(incrementCache xs)

flatten []=[]
flatten (x:xs) = x++(flatten xs)

getSet oldCache bitsNum idx = ((splitEvery (power 2 bitsNum) oldCache) !! idx)
replaceInSet (It (T tag) (D itemdata) validBit order) set | allValid set == True = (replaceIthItem (It (T tag) (D itemdata) validBit order) (incrementCache set) (oldestItem set))
													      |  otherwise = (replaceIthItem (It (T tag) (D itemdata) validBit order) (incrementCache set) (firstError set))

power x 0 = 1
power x y = x*(power x (y-1))


                                           -- Pre-implemented Functions --


getData stringAddress cache memory cacheType bitsNum
	| x == NoOutput = replaceInCache tag index memory cache cacheType bitsNum
	| otherwise = (getX x, cache)
	where
		x = getDataFromCache stringAddress cache cacheType bitsNum
		address = read stringAddress:: Int
		(tag, index) = convertAddress address bitsNum cacheType

getX (Out (d, _)) = d


runProgram [] cache _ _ _ = ([], cache)
runProgram (addr: xs) cache memory cacheType numOfSets = ((d:prevData), finalCache)
													where
														bitsNum = round(logBase2 numOfSets)
														(d, updatedCache) = getData addr cache memory cacheType bitsNum
														(prevData, finalCache) = runProgram xs updatedCache memory cacheType numOfSets