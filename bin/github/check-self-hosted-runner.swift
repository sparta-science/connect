#!/usr/bin/swift

import Quartz

func checkIfScreenIsLocked() {
    if let session = CGSessionCopyCurrentDictionary() as NSDictionary? {
        print(session)
        if let locked = session["CGSSessionScreenIsLocked"] {
            print("screen locked: ", locked)
            print("::warning ::Not ready to run")
            exit(3)
        }
    }
}

checkIfScreenIsLocked()
