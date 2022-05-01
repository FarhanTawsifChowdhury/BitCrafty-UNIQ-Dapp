import React, {useEffect, useState} from 'react';
import '../style/view-all-listed-handicrafts.css';
import {ethers} from 'ethers'
import {marketplaceAddress} from '../../config'
import HandicraftMarketPlace from 'contracts/BitCrafty_Contract.json'

function ViewAllListedHandicrafts() {
    const [handicrafts, setHandicrafts] = useState([])
    const [loadingState, setLoadingState] = useState('not-loaded')
    useEffect(() => {
        loadHandicrafts()
    }, [])

    async function loadHandicrafts() {
        await window.ethereum.enable();
        const provider = new ethers.providers.Web3Provider(window.web3.currentProvider)
        const contract = new ethers.Contract(marketplaceAddress, HandicraftMarketPlace.abi, provider.getSigner())
        try {
            await contract.getTokens()
            const data = await contract.fetchHandicrafts()
            const items = await Promise.all(data.map(async value => {
                const tokenUri = await contract.getTokenURI(value.handicraftId)
                let price = ethers.utils.formatUnits(value.price.toString(), 'ether')
                let item = fetch(tokenUri).then(value => value.json()).then(data =>{
                    console.log(data);
                    let item = {
                        price,
                        handicraftId: value.handicraftId.toNumber(),
                        image: data.image,
                        name: data.name,
                        description: data.description,
                    }
                    return item;
                });
                return item;
            }));
            setHandicrafts(items)
        } catch (error) {
            alert(error.data.message);
            return
        }
        setLoadingState('loaded')
    }

    async function buyItem(handicraft) {
        await window.ethereum.enable();
        const provider = new ethers.providers.Web3Provider(window.web3.currentProvider)
        const contract = new ethers.Contract(marketplaceAddress, HandicraftMarketPlace.abi, provider.getSigner())

        try {
            // const price = ethers.utils.parseUnits(handicraft.price.toString(), 'ether')
            const transaction = await contract.createMarketSale(handicraft.handicraftId)
            await transaction.wait()
        } catch (error) {
            alert(error.data.message);
            return
        }

        loadHandicrafts()
    }

    if (loadingState === 'loaded' && !handicrafts.length) return (
        <h1 className="px-20 py-10 text-3xl">No items in marketplace</h1>)
    return (
        <>
            <div className="handicraftsListedBySellers">
                {
                    handicrafts.map((handicraft, index) =>
                        <div key={index} className="card">
                            <img src={handicraft.image} className="handicraftImage" alt="Product Posted"/>
                            <h1>Name:{handicraft.name}</h1>
                            <p className="price">Price:{handicraft.price} ETH</p>
                            <p>Description:{handicraft.description}</p>
                            <p>
                                <button className="mt-4 w-full bg-pink-500 text-white font-bold py-2 px-12 rounded"
                                        onClick={() => buyItem(handicraft)}>Buy
                                </button>
                            </p>
                        </div>
                    )
                }
            </div>
        </>
    );
}

export default ViewAllListedHandicrafts;
