import React, { useState } from "react"
import styled from 'styled-components'
const Row = styled.div`
  display: flex;
  gap: 1rem;
  align-items: center;
`;
const Button = styled.button`
display: inline-block;
    font-weight: 400;
    color: #212529;
    text-align: center;
    vertical-align: middle;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    background-color: transparent;
    border: 1px solid transparent;
    padding: .375rem .75rem;
    font-size: 1rem;
    line-height: 1.5;
    border-radius: .25rem;
    transition: color .15s;
    color: #007bff;
    border-color: #007bff;
`;
const Title = styled.div`
  font-size: 1.25rem;
  font-family: sans-serif;
`;

const Select = styled.select`
  height: 35px;
  background: white;
  color: gray;
  padding-left: 5px;
  font-size: 1.25rem;
  border: none;
  margin-left: 10px;`

export default function Question(props) {
    const [options, setOptions] = useState(props.options)
    const [title, setTitle] = useState(props.title)
    const [hasQuestion, setHasQuestion] = useState(props.hasQuestion)
    const [isSolved, setIsSolved] = useState(props.isSolved)
    const [answer, setAnswer] = useState(props.probableAnswer)
    return (

        <Row>

            {!isSolved && hasQuestion && (<>
                <Title>
                    Please, enter value for <b> {title}</b>
                </Title>
                <Select>
                    {options.map(el => <option value={el} key={el}>{el}</option>)}
                </Select >
                <Button onClick={(e) => {
                    $.ajax({
                        url: `/quests/${props.id}`,
                        type: 'PATCH',
                        data: {
                            attr: title,
                            value: $('select').val()
                        },
                        success: (data) => {
                            console.log(data)
                            if (data.goal) {
                                const { goal, options } = data
                                setTitle(goal)
                                setOptions(options)
                                setHasQuestion(true)
                            }
                            else {
                                const {is_solved, probable_answer} = data
                                setIsSolved(is_solved)
                                setAnswer(probable_answer)
                                setHasQuestion(false)
                            }

                        }
                    });
                }}> Submit </Button>
            </>)}

            {isSolved && (
                <Title>
                    Your player is: {answer} <a href='/'> See you again in new quest </a>
                </Title>
            )}

            {!isSolved && !hasQuestion && (
                <Title>
                   Don't know such player:( <a href='/'> Let's try again in new quest </a>
                </Title>
            )}

        </Row>
    )
}
