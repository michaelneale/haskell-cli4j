{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}

import Data.Aeson
import Data.Text
import Control.Applicative
import qualified Data.ByteString.Lazy as B
import Network.HTTP.Conduit (simpleHttp)
import GHC.Generics
import Data.HashSet


data Hit = 
  Hit {
    hits :: [HitInfo]
  } deriving (Show)

data HitInfo = 
  HitInfo {
    _id :: !Text 
  } deriving (Show, Generic)
 


instance FromJSON HitInfo
instance ToJSON HitInfo


instance FromJSON Hit
  where parseJSON (Object v) = do toplevel <- v .: "hits"; inner <- toplevel .: "hits"; return (Hit inner)
 

	

olderSet :: String
olderSet = "http://0.0.0.0:8000/test_data.json"

newerSet :: String
newerSet = "http://0.0.0.0:8000/test_data_new.json"



-- Move the right brace (}) from one comment to another
-- to switch from local to remote.

{--
-- Read the local copy of the JSON file.
getJSON :: IO B.ByteString
getJSON = B.readFile jsonFile
--}

{--}
-- Read the remote copy of the JSON file.
getJSON :: String -> IO B.ByteString
getJSON url = simpleHttp url
--}



delta :: Hit -> Hit -> IO ()
delta earlier later =   
  print $ newadditions 
    where previous = extractHits earlier
          newer = extractHits later
          newadditions = difference newer previous
          dropoffs = difference previous newer

 
extractHits :: Hit -> HashSet Text
extractHits hitlist = 
  fromList $ Prelude.map _id (hits hitlist)
  

main :: IO ()
main = do
 -- Get JSON data and decode it
 earlier <- (eitherDecode <$> getJSON olderSet) :: IO (Either String Hit)
 later <- (eitherDecode <$> getJSON newerSet) :: IO (Either String Hit)
 -- If d is Left, the JSON was malformed.
 -- In that case, we report the error.
 -- Otherwise, we perform the operation of
 -- our choice. In this case, just print it.
 case (earlier, later) of  
  (Right e, Right l) -> delta e l
  (Left err, _) -> putStrLn err
  (_, Left err) -> putStrLn err
