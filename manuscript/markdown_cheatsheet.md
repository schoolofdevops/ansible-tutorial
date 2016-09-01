{pagebreak}

- # Part

# Section

## Sub Section

### Sub Sub Section

#### Sub Sub Sub Section

This is the
first para  

This is the 2nd para
separated by a line  
This is the 3rd para separated by 2 spaces at the end of line before  

c>  This is a centered text

*italic*

**bold**

***bold-italic***

____underlined____

1. Numbered list item 1
1. Numbered list item 2

    para between list item 4 indents,
    blank like after prev item, num seq continues

1. Numbered list item 3  


* Bullet list item 1
* Bullet list item 2
  * Sub Item 2.1
    * Sub Sub item 2.1.1
- Bullet list item 3

![caption](images/path_to_image)

Header

: description of the header


> **This is a Block Quote**
>
> Block Quote gets indented
>
> > block quote inside a block quote


**Text Blocks**

Asides

A> ## This is an aside
A>
A> This gets printed in a block

Warnings

W> ## This is a Warning
W>
W> Always wear the seat belt

Tips

T> ## This is a tip
T>
T> Bet for number 5 on that table

Errors

E> ## This prints an error
E>
E> Oops ! You just barged into ladies toilet

Information

I> ## This is to print info
I>
I>  For your eyes only


Questions

Q> ## This prints questions
Q>
Q> What came first, chicken or the engg?


Discussions

D> ## This is for Discussions
D>
D> Lets talk about Life of Pie


Exercises

X> ## This is for exercises
X>
X> 10 mins on treadmill
X> followed by two sets of pushups

**Writing Code**

Method 1 : 4 space indentation

    echo "this starts with 4 indents"
    ls -l
    cat /etc/issue
    uptime

Method 2: 8 tildes

~~~~~~~~
echo "this has 8 tildes on the top and bottom"
echo "8 tildes is a best practice, but any no. will do "
uptime
ls -l
cat /etc/issue
~~~~~~~~

Method 3 : include code from file

<<(code/sample_code.sh)

<<[sample_code_with_title](code/sample_code.sh)

Method 4 : lp-code style

{title="Listing ", lang=html, linenos=off}
~~~~~~~
echo "this is autocompleted by leanpub plugin for atom"
uptime
df -h
ls -l  
~~~~~~~

Method 5: back ticks ``

`echo "this is a short code snippet"`


**Footnotes**

This is a text para
and I am writing a
footnote[^tag1] here

Later on I add the footnote as

[^tag1]: description about the footnote. Should contain blank line before and after


**Crosslinks**

This is a cross link to {##Sub Section}

**Table**

| header1 | header2
|---------|---------
| r1-c1 | r1-c2
| r2-c1 | r2-c2
| r3-c1 | r3-c2

| Header One     | Header Two     |
| :------------- | :------------- |
| Item One       | Item Two       |
