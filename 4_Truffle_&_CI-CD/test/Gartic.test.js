const { BN, ether, expectRevert, expectEvent } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const Gartic = artifacts.require('Gartic');

contract('Gartic', function([owner, reciever]) {

  beforeEach(async function () {
    this.GarticInstance = await Gartic.new();
  });

  it('tests store function, if the first word is the last in the list', async function (){
    const w = 'hello';
    const words = await this.GarticInstance.GetWords();
    expect(words.length).equal(0);
    await this.GarticInstance.StoreWord(w, { from: reciever });
    const wordList = await this.GarticInstance.GetWords();
    const lastWord = await this.GarticInstance.GetLastWord();
    expect(wordList.length).equal(1);
    expect(lastWord).equal(w);
  });

  it('test getResult call if the game is not finished', async function() {
    await expectRevert(this.GarticInstance.getResults(),'jeu pas encore fini.')
  });

  it('test getLastWord function', async function() {
    const lastWord = await this.GarticInstance.GetLastWord();
    expect(lastWord).equal("");
    await this.GarticInstance.StoreWord('yolo');
    const lastword2 = await this.GarticInstance.GetLastWord();
    expect(lastword2).equal('yolo');
  });

  it ('test guessIt function, if not end od the game', async function() {
    await expectRevert(this.GarticInstance.guessIt('mocha'),  "Pas à la bonne étape du jeu");
  });

  it ('test reject after inserting the same word', async function() {
    await this.GarticInstance.StoreWord('yolo');
    await expectRevert(this.GarticInstance.StoreWord('yolo'), "Can't write same word !")
  });

  it ('test reject after user trys to insert 2 times', async function() {
    await this.GarticInstance.StoreWord('yolo', { from: reciever });
    await expectRevert(this.GarticInstance.StoreWord('hm', { from: reciever }), "t'as déjà joué!");
  })
})