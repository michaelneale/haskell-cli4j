{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}

import Data.Aeson
import Data.Text
import Control.Applicative
import Control.Monad
import qualified Data.ByteString.Lazy as B
import Network.HTTP.Conduit (simpleHttp)
import GHC.Generics


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
 

	

-- this is the jenkins Jobs api - a pre canned response. No auth required.
jenkinsApi :: String
-- jenkinsApi = "https://gist.githubusercontent.com/michaelneale/6c8f494100e37d33424d/raw/aa09039b180a704629d5c9c844d64c43b511bf06/gistfile1.json"
--jenkinsApi = "http://api.meanpath.com/meanpath_current/_search?q=bgp%3A%2240670%22%20AND%20(%22Default.asp%22%20OR%20meta%3A%22vsettings%22%20OR%20%22var%20Config_VCompare_MaxProducts%22%20OR%20%22volusion.ready%22%20OR%20%22coming%20soon%22%20OR%20%22Thank%20you%20for%20visiting%22%20OR%20%22%5C%2Fv%5C%2Fvspfiles%22%20OR%20%22servertrust.com%22%20OR%20%22Closed%20for%20maintainence%22)&pretty&fields=domain,redirect,domain_ip,redirect_ip,bgp&size=10"
jenkinsApi = "http://0.0.0.0:8000/test_data.json"


-- Move the right brace (}) from one comment to another
-- to switch from local to remote.

{--
-- Read the local copy of the JSON file.
getJSON :: IO B.ByteString
getJSON = B.readFile jsonFile
--}

{--}
-- Read the remote copy of the JSON file.
getJSON :: IO B.ByteString
getJSON = simpleHttp jenkinsApi
--}

difference :: Hit -> IO ()
difference h =   
  print $ hits h
  

main :: IO ()
main = do
 -- Get JSON data and decode it
 d <- (eitherDecode <$> getJSON) :: IO (Either String Hit)
 -- If d is Left, the JSON was malformed.
 -- In that case, we report the error.
 -- Otherwise, we perform the operation of
 -- our choice. In this case, just print it.
 case d of
  Left err -> putStrLn err
  Right ps -> difference ps
