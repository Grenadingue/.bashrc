#!/bin/bash

set -e

SCRIPT_NAME="$(basename "${0}")"

ARG_ENCRYPT="false"
ARG_DECRYPT="false"
OPT_OUTPUT="false"
ARG_INPUT_KEY="false"
ARG_CREATE_KEY="false"
OPT_VERBOSE="false"
OPT_HELP="false"
TARGET_INPUT_PATH=""
OUTPUT_PATH=""
INPUT_KEY_PATH=""

function main()
{
  read_args "${@}"
  parse_args
  secure_file_handler
  exit ${?}
}

function usage()
{
  cat >&2 << EOF

  SYNOPSIS:
    ${SCRIPT_NAME} --create-key|-c --output|-o <FILE> [OPTIONS]
    ${SCRIPT_NAME} --encrypt|-e <FILE> | --decrypt|-d <FILE> --key|-k <FILE> --output|-o <FILE> [OPTIONS]
  WHAT IS THIS?
    A tool which allow simple secure file encryption/decryption
  EXAMPLE:
    ${SCRIPT_NAME} --create-key --output myKey.txt
    ${SCRIPT_NAME} --encrypt mySuperSecret.txt --key myKey.txt --output mySuperSecret.txt.encrypted.bin
    ${SCRIPT_NAME} --decrypt mySuperSecret.txt.encrypted.bin --key myKey.txt --output mySuperSecret.decrypted.txt
  FILE:
    Path to a file
  OPTIONS:
    -v|--verbose : Displays what's happening in the background
    -h|--help : Displays this message
  NOTE: FIXME:
    Short options concatenation parsing has been disabled
EOF
}

function read_args()
{
  local OPTS

  OPTS=$(getopt \
    --options ce:d:o:k:vh \
    --long create-key,encrypt:,decrypt:,output:,key:,verbose,help \
    --name "secure_file_encryption" \
    -- "${@}")

  if [ ${?} != 0 ]; then
    usage
    exit 1
  fi

  #
  # FIXME: getopt fails to detect -e option in some cases.
  # Short options concatenation has been disabled
  #
  # # echo $OPTS
  # # eval set -- "${OPTS}"

  while true; do
    case "${1}" in
      -e | --encrypt ) ARG_ENCRYPT=true; TARGET_INPUT_PATH="${2}"; shift; shift ;;
      -d | --decrypt ) ARG_DECRYPT=true; TARGET_INPUT_PATH="${2}"; shift; shift ;;
      -o | --output ) OPT_OUTPUT=true; OUTPUT_PATH="${2}"; shift; shift ;;
      -k | --key ) ARG_INPUT_KEY=true; INPUT_KEY_PATH="${2}"; shift; shift ;;
      -c | --create-key ) ARG_CREATE_KEY=true; shift ;;
      -v | --verbose ) OPT_VERBOSE=true; shift ;;
      -h | --help ) OPT_HELP=true; shift ;;
      -- ) shift; break ;;
      * ) break ;;
    esac
  done
}

function parse_args()
{
    if [ "${HELP}" == "true" ]; then
    usage
    exit 0
  elif [ "${ARG_ENCRYPT}" == "false" ] && [ "${ARG_DECRYPT}" == "false" ] && [ "${ARG_CREATE_KEY}" == "false" ]; then
    echo "Error: No action given" >&2
    usage
    exit 10
  elif [ "${ARG_ENCRYPT}" == "true" ] && [ "${ARG_DECRYPT}" == "true" ] && [ "${ARG_CREATE_KEY}" == "true" ]; then
    echo "Error: Too many actions given at the same time" >&2
    usage
    exit 11
  elif [ "${ARG_ENCRYPT}" == "true" ] && [ "${ARG_DECRYPT}" == "true" ]; then
    echo "Error: Too many actions given at the same time" >&2
    usage
    exit 11
  elif [ "${ARG_DECRYPT}" == "true" ] && [ "${ARG_CREATE_KEY}" == "true" ]; then
    echo "Error: Too many actions given at the same time" >&2
    usage
    exit 11
  elif [ "${ARG_ENCRYPT}" == "true" ] && [ "${ARG_CREATE_KEY}" == "true" ]; then
    echo "Error: Too many actions given at the same time" >&2
    usage
    exit 11
  elif [ "${ARG_CREATE_KEY}" = "true" ] && [ "${OPT_OUTPUT}" = "false" ]; then
      echo "Error: Option --output|-o <FILE> must be used alongside --create-key|-c" >&2
      usage
      exit 20
  elif [ "${ARG_ENCRYPT}" = "true" ] && [ "${OPT_OUTPUT}" = "false" ]; then
      echo "Error: Option --output|-o <FILE> must be used alongside --encrypt|-e" >&2
      usage
      exit 21
  elif [ "${ARG_DECRYPT}" = "true" ] && [ "${OPT_OUTPUT}" = "false" ]; then
      echo "Error: Option --output|-o <FILE> must be used alongside --decrypt|-d" >&2
      usage
      exit 22
  elif [ "${ARG_ENCRYPT}" = "true" ] || [ "${ARG_DECRYPT}" = "true" ]; then
    if [ ! -f "${TARGET_INPUT_PATH}" ]; then
      echo "Error: Given input file '${TARGET_INPUT_PATH}' does not exist or is not a regular file" >&2
      echo >&2
      exit 30
    fi
  elif [ "${ARG_ENCRYPT}" = "true" ] && [ "${ARG_INPUT_KEY}" = "false" ]; then
      echo "Error: Option --key|-k <FILE> must be used alongside --encrypt|-e" >&2
      usage
      exit 40
  elif [ "${ARG_DECRYPT}" = "true" ] && [ "${ARG_INPUT_KEY}" = "false" ]; then
      echo "Error: Option --key|-k <FILE> must be used alongside --decrypt|-d" >&2
      usage
      exit 41
  fi
}

function secure_file_handler()
{
    if [ "${OPT_VERBOSE}" = "true" ]; then
	set -x
    fi

    if [ "${ARG_CREATE_KEY}" = "true" ]; then
	handle_key_creation
    elif [ "${ARG_ENCRYPT}" = "true" ]; then
	handle_file_encryption
    elif [ "${ARG_DECRYPT}" = "true" ]; then
	handle_file_decryption
    fi
}

function handle_key_creation()
{
    random_key 128 > "${OUTPUT_PATH}"
}

function handle_file_encryption()
{
    encrypt "${INPUT_KEY_PATH}" "${TARGET_INPUT_PATH}" "${OUTPUT_PATH}"
}

function handle_file_decryption()
{
    decrypt "${INPUT_KEY_PATH}" "${TARGET_INPUT_PATH}" "${OUTPUT_PATH}"
}

function random_key()
{
    < /dev/urandom tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' | head -c "${1}"
    echo
}

function encrypt()
{
    openssl enc -chacha20 -md sha512 -pbkdf2 -iter 1042 -salt -pass file:"${1}" -in "${2}" -out "${3}"
}

function decrypt()
{
    openssl enc -d -chacha20 -md sha512 -pbkdf2 -iter 1042 -salt -pass file:"${1}" -in "${2}" -out "${3}"
}

main "${@}"
