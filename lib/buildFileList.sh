#!/usr/bin/env bash
# shellcheck disable=SC2034

################################################################################
################################################################################
########### Super-Linter Build File List Functions @admiralawkbar ##############
################################################################################
################################################################################
########################## FUNCTION CALLS BELOW ################################
################################################################################
################################################################################
#### Function BuildFileList ####################################################
function BuildFileList()
{
  # Need to build a list of all files changed
  # This can be pulled from the GITHUB_EVENT_PATH payload

  ################
  # print header #
  ################
  if [[ "$ACTIONS_RUNNER_DEBUG" == "true" ]]; then
    echo ""
    echo "----------------------------------------------"
    echo "Pulling in code history and branches..."
  fi

  #################################################################################
  # Switch codebase back to the default branch to get a list of all files changed #
  #################################################################################
  SWITCH_CMD=$(cd "$GITHUB_WORKSPACE" || exit; git pull --quiet; git checkout "$DEFAULT_BRANCH" 2>&1)

  #######################
  # Load the error code #
  #######################
  ERROR_CODE=$?

  ##############################
  # Check the shell for errors #
  ##############################
  if [ $ERROR_CODE -ne 0 ]; then
    # Error
    echo "Failed to switch to $DEFAULT_BRANCH branch to get files changed!"
    echo "ERROR:[$SWITCH_CMD]"
    exit 1
  fi

  ################
  # print header #
  ################
  if [[ "$ACTIONS_RUNNER_DEBUG" == "true" ]]; then
    echo ""
    echo "----------------------------------------------"
    echo "Generating Diff with:[git diff --name-only '$DEFAULT_BRANCH..$GITHUB_SHA' --diff-filter=d]"
  fi

  #################################################
  # Get the Array of files changed in the commits #
  #################################################
  # shellcheck disable=SC2207
  RAW_FILE_ARRAY=($(cd "$GITHUB_WORKSPACE" || exit; git diff --name-only "$DEFAULT_BRANCH..$GITHUB_SHA" --diff-filter=d 2>&1))

  #######################
  # Load the error code #
  #######################
  ERROR_CODE=$?

  ##############################
  # Check the shell for errors #
  ##############################
  if [ $ERROR_CODE -ne 0 ]; then
    # Error
    echo "ERROR! Failed to gain a list of all files changed!"
    echo "ERROR:[${RAW_FILE_ARRAY[*]}]"
    exit 1
  fi

  ################################################
  # Iterate through the array of all files found #
  ################################################
  echo ""
  echo "----------------------------------------------"
  echo "Files that have been modified in the commit(s):"
  for FILE in "${RAW_FILE_ARRAY[@]}"
  do
    ##############
    # Print file #
    ##############
    echo "File:[$FILE]"

    ###########################
    # Get the files extension #
    ###########################
    # Extract just the file and extension, reverse it, cut off extension,
    # reverse it back, substitute to lowercase
    FILE_TYPE=$(basename "$FILE" | rev | cut -f1 -d'.' | rev | awk '{print tolower($0)}')

    #########
    # DEBUG #
    #########
    #echo "FILE_TYPE:[$FILE_TYPE]"

    #####################
    # Get the YML files #
    #####################
    if [ "$FILE_TYPE" == "yml" ] || [ "$FILE_TYPE" == "yaml" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_YML+=("$FILE")
      ############################
      # Check if file is OpenAPI #
      ############################
      if DetectOpenAPIFile "$FILE"; then
        FILE_ARRAY_OPENAPI+=("$FILE")
      fi
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    ######################
    # Get the JSON files #
    ######################
    elif [ "$FILE_TYPE" == "json" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_JSON+=("$FILE")
      ############################
      # Check if file is OpenAPI #
      ############################
      if DetectOpenAPIFile "$FILE"; then
        FILE_ARRAY_OPENAPI+=("$FILE")
      fi
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    #####################
    # Get the XML files #
    #####################
    elif [ "$FILE_TYPE" == "xml" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_XML+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    ##########################
    # Get the MARKDOWN files #
    ##########################
    elif [ "$FILE_TYPE" == "md" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_MD+=("$FILE")
    ######################
    # Get the BASH files #
    ######################
    elif [ "$FILE_TYPE" == "sh" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_BASH+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    ######################
    # Get the PERL files #
    ######################
    elif [ "$FILE_TYPE" == "pl" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_PERL+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    ######################
    # Get the PHP files #
    ######################
    elif [ "$FILE_TYPE" == "php" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_PHP+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    ######################
    # Get the RUBY files #
    ######################
    elif [ "$FILE_TYPE" == "rb" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_RUBY+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    ########################
    # Get the PYTHON files #
    ########################
    elif [ "$FILE_TYPE" == "py" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_PYTHON+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    ########################
    # Get the COFFEE files #
    ########################
    elif [ "$FILE_TYPE" == "coffee" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_COFFEESCRIPT+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    ############################
    # Get the JavaScript files #
    ############################
    elif [ "$FILE_TYPE" == "js" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_JAVASCRIPT_ES+=("$FILE")
      FILE_ARRAY_JAVASCRIPT_STANDARD+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    ############################
    # Get the TypeScript files #
    ############################
    elif [ "$FILE_TYPE" == "ts" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_TYPESCRIPT_ES+=("$FILE")
      FILE_ARRAY_TYPESCRIPT_STANDARD+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    ########################
    # Get the Golang files #
    ########################
    elif [ "$FILE_TYPE" == "go" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_GO+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    ###########################
    # Get the Terraform files #
    ###########################
    elif [ "$FILE_TYPE" == "tf" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_TERRAFORM+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    ###########################
    # Get the Powershell files #
    ###########################
    elif [ "$FILE_TYPE" == "ps1" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_POWERSHELL+=("$FILE")
    elif [ "$FILE_TYPE" == "css" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_CSS+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    elif [ "$FILE_TYPE" == "env" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_ENV+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    elif [ "$FILE_TYPE" == "kt" ] || [ "$FILE_TYPE" == "kts" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_KOTLIN+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    ############################
    # Get the Protocol Buffers files #
    ############################
    elif [ "$FILE_TYPE" == "proto" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_PROTOBUF+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    elif [ "$FILE" == "Dockerfile" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_DOCKER+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    elif [ "$FILE_TYPE" == "clj" ] || [ "$FILE_TYPE" == "cljs" ] || [ "$FILE_TYPE" == "cljc" ] || [ "$FILE_TYPE" == "edn" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_CLOJURE+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    else
      ##############################################
      # Use file to see if we can parse what it is #
      ##############################################
      GET_FILE_TYPE_CMD=$(file "$FILE" 2>&1)

      #################
      # Check if bash #
      #################
      if [[ "$GET_FILE_TYPE_CMD" == *"Bourne-Again shell script"* ]]; then
        #######################
        # It is a bash script #
        #######################
        echo "WARN! Found bash script without extension:[.sh]"
        echo "Please update file with proper extensions."
        ################################
        # Append the file to the array #
        ################################
        FILE_ARRAY_BASH+=("$FILE")
        ##########################################################
        # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
        ##########################################################
        READ_ONLY_CHANGE_FLAG=1
      elif [[ "$GET_FILE_TYPE_CMD" == *"Ruby script"* ]]; then
        #######################
        # It is a Ruby script #
        #######################
        echo "WARN! Found ruby script without extension:[.rb]"
        echo "Please update file with proper extensions."
        ################################
        # Append the file to the array #
        ################################
        FILE_ARRAY_RUBY+=("$FILE")
        ##########################################################
        # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
        ##########################################################
        READ_ONLY_CHANGE_FLAG=1
      else
        ############################
        # Extension was not found! #
        ############################
        echo "  - WARN! Failed to get filetype for:[$FILE]!"
        ##########################################################
        # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
        ##########################################################
        READ_ONLY_CHANGE_FLAG=1
      fi
    fi
  done

  #########################################
  # Need to switch back to branch of code #
  #########################################
  SWITCH2_CMD=$(cd "$GITHUB_WORKSPACE" || exit; git checkout --progress --force "$GITHUB_SHA" 2>&1)

  #######################
  # Load the error code #
  #######################
  ERROR_CODE=$?

  ##############################
  # Check the shell for errors #
  ##############################
  if [ $ERROR_CODE -ne 0 ]; then
    # Error
    echo "Failed to switch back to branch!"
    echo "ERROR:[$SWITCH2_CMD]"
    exit 1
  fi

  ################
  # Footer print #
  ################
  echo ""
  echo "----------------------------------------------"
  echo "Successfully gathered list of files..."
}