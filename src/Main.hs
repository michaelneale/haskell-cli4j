{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}

import Data.Aeson
import Data.Text
import Control.Applicative
import Control.Monad
import qualified Data.ByteString.Lazy as B
import Network.HTTP.Conduit (simpleHttp)
import GHC.Generics


-- Jenkins Jobs api
data Jobs = 
  Jobs {
    jobs :: [Job]
  } deriving (Show, Generic)

data Job =
  Job {
    name :: !Text,
    url :: !Text
  } deriving (Show, Generic)


instance FromJSON Job
instance ToJSON Job

instance FromJSON Jobs
instance ToJSON Jobs



-- this is the jenkins Jobs api - a pre canned response. No auth required.
jenkinsApi :: String
jenkinsApi = "https://gist.githubusercontent.com/michaelneale/6c8f494100e37d33424d/raw/aa09039b180a704629d5c9c844d64c43b511bf06/gistfile1.json"


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

main :: IO ()
main = do
 -- Get JSON data and decode it
 d <- (eitherDecode <$> getJSON) :: IO (Either String Jobs)
 -- If d is Left, the JSON was malformed.
 -- In that case, we report the error.
 -- Otherwise, we perform the operation of
 -- our choice. In this case, just print it.
 case d of
  Left err -> putStrLn err
  Right ps -> print ps