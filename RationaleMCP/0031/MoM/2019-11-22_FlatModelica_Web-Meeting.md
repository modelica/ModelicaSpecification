Meeting Date: 10.10.2019 09:00 Location: Skype Meeting
# Participants

    Henrik Tildefeit (Wolfram)
    Kai Werther (ETAS)
    Gerd Kurzbach (ESI-ITI)
    Christoff Bürger (DS)
    Hans Olsson (DS)
    Martin Sjölund (LiU)
    Francesco Casella (Politecnico di Milano)
    Giovanni Agosta (Politecnico di Milano)
    Stefano Cherubin (Politecnico di Milano)
    Terraneo (Politecnico di Milano)
    Oliver Lenord (Bosch)

# Notes

## Introduction
Brief introduction of all participants
Main interest of Politecnico di Milano is to work on a research project for a high performance compiler for large scale models.

Summary of the current work, documents on github and status of discussion by Henrik.

## Questions:
Franscesco: Non-trivial issue with fluid models are arrays and records
Henrik: We will need arrays and records but its up to the tools to decide on the level of scalarization. Flat may be understood as fully scalarized, but in
Francesco

How to start the discussion?
black listing vs. white listing
Approach: black list the obvious, white list what is needed for eFMI EqCode, have discussion threads for all items that are contorversial.
Follow the outlined scheme: Principles for use of language constructs vs annotations.
Post pone this topic to the next meeting as Gerd has to leave.


## Express hybrid DAE
Kai: SCODE-CONGRA has a separate switching logic appart from the continuous equations. Will spend some thought on this unti next time.

## To Dos until next meeting
Split the current oull request into smaller chunks:
* Create an annotations.md file and linking it to the list. [Henrik]
* Comment on this pull request [Gerd + all]
* Discuss and decide this at the next meeting.

## Next Meeting
Friday 6th, 11.00AM
