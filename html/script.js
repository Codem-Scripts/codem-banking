let bankMoney = null
var myChart
let playerChoice = null;
//Vue
const APP = new Vue({
    el: "#app",

    data: {
        menuData: {
            fastActions: {
                isOpen: false,
                subMenus: {
                    deposit: false,
                    withdraw: false,
                },
            },
        }
    },
    methods: {
        toggleFast() {


            this.menuData['fastActions'].isOpen = !this.menuData['fastActions'].isOpen
            if (!this.menuData['fastActions'].isOpen) {
                this.menuData['fastActions']['subMenus']['deposit'] = false
                this.menuData['fastActions']['subMenus']['withdraw'] = false
            }
        },

        toggleDeposit() {
            this.menuData['fastActions']['subMenus']['deposit'] = !this.menuData['fastActions']['subMenus']['deposit']

        },

        toggleWithdraw() {
            this.menuData['fastActions']['subMenus']['withdraw'] = !this.menuData['fastActions']['subMenus']['withdraw']

        }
    },
    mounted() {
        // console.log('mounted')
    }
})




window.addEventListener("message", function (event) {
    let data = event.data
    if (data.action == true) {
        createChart(data.data.expense_data)
        EditMyInfos(data.data)
        EditAccordingToStatus(data.color)

    } else if (data.action == "updateBankBalance") {

        console.log('data value : ', data.value)
        UpdateBankBalance(data.value, data.type)
    } else if (data.action == "setTransactionHistory") {
        
        setTransactionHistory(data.transactionHistory)

    }
})




$(document).keydown(function (e) {
    if (e.keyCode == 27) {
        $('#container').fadeOut();
        $.post('http://codem-banking/codem:CloseNUI');
        // console.log(e.keyCode)
    }
});









// Functions





function setTransactionHistory(history) {
    let html = ``

    let el = $('.group-accounts-history-flex')
    if (history) {
        history.forEach(function (data) {

            html += `<div class="transaction w-50  ${data.type == 'outgoing' ? 'outgoing' : ' incoming'} ">
                     <p>${data.label}
                     </p>
                      ${data.type == 'outgoing' ? ' <i class="fas fa-chevron-down"></i>' : ' <i class="fas fa-chevron-up"></i>'}           
                 </div> `
        })

    }


    el.html(html)
}

createChart({ oneweek : 100, threedays : 100, twodays : 100, yesterday : 100, today : 100})
function createChart(moneydata) {

    if (myChart != undefined) {
        myChart.destroy()
    }
    const data = {
        labels: ['One Week Ago', 'Three Days Ago', 'Two Days Ago', 'Yesterday', 'Today',],


        datasets: [{
            label: 'Expenses',
            data: [moneydata.oneweek, moneydata.threedays, moneydata.twodays, moneydata.yesterday, moneydata.today],
            fill: false,
            borderColor: '#FE7A15',
            tension: 0.1
        }]
    };


    const config = {
        type: 'line',
        data: data,

        options: {
            plugins: {
                legend: {
                    display: false
                }
            },

            scales: {
                x: {
                    grid: {
                        display: false,
                    }
                },
                y: {
                    grid: {
                        borderDash: [2, 2],
                        color: function (context) {
                            if (context.tick.value === 0) {
                                return 'rgba(255, 255, 255, 0.0)';
                            }
                            return 'rgba(255, 255, 255, 0.1)';
                        },
                    }
                },
            }
        }
    };


    var ctx = document.getElementById('myChart');
    myChart = new Chart(ctx, config);
}

AccessWrite = function (color) {
    // console.log(color)

    if (color == "green") {
        $(".revo").css("color", "#26ab3c")
        $(".rell").css("color", "#26ab3c")
        myChart.data.datasets[0].borderColor = '#26ab3c';
        myChart.update();
    } else if (color == "red") {
        $(".revo").css("color", "#9c1c1c")
        $(".rell").css("color", "#9c1c1c")
        myChart.data.datasets[0].borderColor = '#9c1c1c';
        myChart.update();
    } else if (color == "blue") {
        $(".revo").css("color", "#298f77")
        $(".rell").css("color", "#298f77")
        myChart.data.datasets[0].borderColor = '#298f77';
        myChart.update();
    } else if (color == "red") {
        $(".revo").css("color", "#26ab3c")
        $(".rell").css("color", "#26ab3c")
        myChart.data.datasets[0].borderColor = '#26ab3c';
        myChart.update();
    } else if (color == "lightblue") {
        $(".revo").css("color", "#1441c9")
        $(".rell").css("color", "#1441c9")
        myChart.data.datasets[0].borderColor = '#1441c9';
        myChart.update();
    }
}


EditAccordingToStatus = function (color) {
    if (color == "red") {
        $(".button").css("background-color", "#9c1c1c")
        $(".color-pink").css("color", "#9c1c1c")
        $(".revo").css("color", "#9c1c1c")
        
        $('.button-transfer').css("background-color", "#9c1c1c")
        myChart.data.datasets[0].borderColor = '#9c1c1c';


        myChart.update();
    } else if (color == "green") {
        $(".button").css("background-color", "#26ab3c")
        $(".color-pink").css("color", "#26ab3c")
        $(".revo").css("color", "#26ab3c")
        $('.button-transfer').css("background-color", "#26ab3c")

        myChart.data.datasets[0].borderColor = '#26ab3c';
        myChart.update();
    } else if (color == "blue") {
        $(".button").css("background-color", "#298f77")
        $(".color-pink").css("color", "#298f77")
        $(".revo").css("color", "#298f77")
        $('.button-transfer').css("background-color", "#298f77")

        myChart.data.datasets[0].borderColor = '#298f77';
        myChart.update();
    } else if (color == "lightblue") {
        $(".button").css("background-color", "#1441c9")
        $(".color-pink").css("color", "#1441c9")
        $(".revo").css("color", "#1441c9")
        $('.button-transfer').css("background-color", "#1441c9")

        myChart.data.datasets[0].borderColor = '#1441c9';
        myChart.update();
    }
    playerChoice = color
}

UpdateBankBalance = function (val, type) {

    let currentBalance = document.getElementById("bankbalance").innerHTML
    currentBalance = currentBalance.slice(1, currentBalance.length)
    console.log(currentBalance)
    if (type == "deposit") {

        document.getElementById("bankbalance").innerHTML = '$' + (Number(currentBalance) + Number(val)).toString()
        $('#small-text-w-info').text('You have $' + (Number(currentBalance) + Number(val)) + ' in your bank.')


    } else if (type == "withdraw") {
        document.getElementById("bankbalance").innerHTML = '$' + (Number(currentBalance) - Number(val)).toString()
        $('#small-text-w-info').text('You have $' + (Number(currentBalance) - Number(val)) + ' in your bank.')
    } 
}


EditMyInfos = function (data) {

    $('#container').fadeIn();

    document.getElementById("container").style.display = "flex"
    // console.log(data.lenght)
    // console.log(JSON.stringify(data))
    document.getElementById("name").innerHTML = "&nbsp;" + data.name
    document.getElementById("bankbalance").innerHTML = '$' + data.bank
    document.getElementById("bills").innerHTML = data.lenght
    document.getElementById("incom").innerHTML = "$" + data.incoming
    data.citizenid =  data.citizenid.substring(6 , 15  ) 
    $('.number').text(data.citizenid)
    $('.cardHolder').text(data.fullname)
    Billinghistory()
    TransactionData()
}



TransactionData = function () {
    $.post('http://codem-banking/codem:GetTotalBills', JSON.stringify({}), function (cbData) {
        let bills = ""
        if (cbData.length > 0) {
            for (let index = 0; index < cbData.length; index++) {
                const data = cbData[index];

                bills = `
            <div id="${data.id}" class="bills-section">
                <p> ${data.label}</p>
                <p style="color:#9c1c1c" bill-amount="${data.amount}">&nbsp;&nbsp;&nbsp;&nbsp;${data.amount}$</p>
                <div class="pay-bill-button" bill-label= "${data.label}" bill-id="${data.id} ">Pay</div>
            </div>
            ` + bills
            }
        } else {
            bills = `
        <div class="bills-section">
            <p>You have no bills.</p>
        </div>
            ` + bills

        }
        $(".color-bills").html(bills)
    });
}


Billinghistory = function () {
    $.post('http://codem-banking/codem:FetchInvoice', JSON.stringify({}), function (cbData) {
        let billingData = ""
        for (let index = 0; index < cbData.length; index++) {
            const element = cbData[index];
            billingData = `
            
            <div class= "transaction outgoing">
                <p>Amount : ${element.amount}$ Reason :  ${element.label} </p>
            </div>
            ` + billingData

        }
        $(".billing-history").html(billingData)
    });
    $(".billing-history").fadeIn(500);
}





destroyDialog = function () {

    let dialogMenu = $('.dialog-menu')

    dialogMenu.fadeOut(500, function () {
        dialogMenu.css('display', 'none')
        dialogMenu.html('')
    })


}


createDialog = function(type) {
    let dialogMenu = $('.dialog-menu')

    dialogMenu.html('')


    if (type == 'withdraw') {
        let data = createWithdrawMenu();
        dialogMenu.html(data)
    } else if (type == 'deposit') {
        let data = createDepositMenu();
        dialogMenu.html(data)
    } else if (type == 'transfer') {
        let data = createTransferMenu()
        dialogMenu.html(data)
        createPlayers()
    }

    EditAccordingToStatus(playerChoice)
    dialogMenu.fadeIn(500)
    dialogMenu.css('display', 'flex')


}



createDepositMenu = function () {

    let currentBalance = document.getElementById("bankbalance").innerHTML
    currentBalance = currentBalance.slice(1, currentBalance.length)
    let html = `
        <div class="withdraw-label">Deposit Money</div>
            <span class="small-text"  id="small-text-w-info">You have $${currentBalance} in your bank</span>
                <div class="group-dialog-withdraw">
                    <div class="withdraw-input-group">
                        <input class="withdraw-input" id="deposit-input" type="number" style="color:rgb(82, 82, 82); font-size:20px;" value="0">
                    </div>
                <div class="button" id="confirm-deposit">Deposit</div>
            <div class="close-dialog">X</div>
        </div>
    `


    return html;
}


createPlayers = function (filter) {
    let html = ``
    $.post("http://codem-banking/codem:RequestPlayers", JSON.stringify({}), function (result) {
        if (result) {

            if (filter) {
                result = result.filter((player) => {
                    let fullname = (player.firstname + ' ' + player.lastname).toLowerCase()
                    return fullname.startsWith(filter.toLowerCase())
                })
            }

            result.forEach((player, index) => {
                
                html = ` <option selected=${index == 0} value="${player.identifier}"> ${player.firstname} ${player.lastname}</option>` + html
            });
        }
        $('.select-player').html(html)

    })
}





createTransferMenu = function () {

    let html = ` 
            <div class="transfer-label">Transfer Money</div>
            <div class="transfer-input-group">
                <input class="transfer-input" id="transfer-input" type="number"
                    style="color:rgb(82, 82, 82); font-size:20px;" value="0">
            </div>
    
            <div class="group-dialog">
                <div class="transfer-filter-group">
                    <input class="transfer-input" id="filter-input" type="text"
                    style="color:rgb(82, 82, 82); font-size:14px;" placeholder="filter a player by firstname">
                </div>
    
    
                <select class="select-player"> 
        
                    
                </select>
            </div>
            <div class="close-dialog">X</div>
    
            <div class="button-transfer" id="confirm-transfer">Transfer</div>
    
        `
    return html;
}






createWithdrawMenu = function () {

    let currentBalance = document.getElementById("bankbalance").innerHTML
    currentBalance = currentBalance.slice(1, currentBalance.length)
    let html = `
        <div class="withdraw-label">Withdraw Money</div>
            <span class="small-text" id="small-text-w-info">You have $${currentBalance} in your bank</span>
                <div class="group-dialog-withdraw">
                    <div class="withdraw-input-group">
                        <input class="withdraw-input" id="withdraw-input" type="number" style="color:rgb(82, 82, 82); font-size:20px;" value="0">
                    </div>
                <div class="button" id="confirm-withdraw">Withdraw</div>
            <div class="close-dialog">X</div>
        </div>
    `


    return html;
}


notify = function (text, type) {
    $(".notify").fadeOut(0)
    let renk = "#333"
    if (type == "error") {
        renk = "#A52A2A"
    } else if (type == "success") {
        renk = "#689f38"
    }
    $(".notify").fadeIn(100)
    $(".notify").html(text)
    $(".notify").css("background", renk);
    $(".notify").animate({ right: "0" }, 500, function () {
        setTimeout(() => {
            $(".notify").animate({ right: "0" }, 500, function () {
                $(".notify").fadeOut(100)
            });
        }, 1000);
    });
}




// Clicks







$(document).on('click', '#confirm-transfer', function (e) {

    let cid = $('.select-player').val();
    let amount = $('#transfer-input').val();

    if (amount <= 0 || isNaN(amount)) {
        notify("Invalid amount.", "error")
        return
    }
    console.log(cid)
    if (cid != '' && cid != undefined && cid != null) {
        $.post('http://codem-banking/codem:TransferMoney', JSON.stringify({
            citizenid: cid, amount
        }), function (data) {
            if(data.type == 'success'){
                notify("You transfered $" + data.amount, "success")

                UpdateBankBalance(data.amount, 'withdraw')
            } else if (data.type == "self") {
                notify("You can't transfer to yourself", "error")
            } else if (data.type == 'nomoney') {
                notify("You don't have enough balance.", "error")
            }
        })
    } else {
        notify("You haven't selected someone.", "error")
    }


})


$(".close").click(function () {
    console.log('clicked')
    $('#container').fadeOut();
    $.post('http://codem-banking/codem:CloseNUI');
})


$(document).on('click', '.pay-bill-button', function (e) {
    const billId = $(this).attr("bill-id")
    const billLabel = $(this).attr("bill-label")
    const billAmount = $(this).prev().attr("bill-amount")
    $.post('http://codem-banking/codem:SaveInvoice', JSON.stringify({
        billId, billLabel, billAmount

    }), function (result) {
        if (result) {
            $("#" + billId).fadeOut(1000);
            notify("Payment completed.", "success")


            UpdateBankBalance(billAmount, "withdraw")
            Billinghistory()
        } else {
            notify("You don't have enough balance.", "error")
        }

    });

})




$(document).on('click', '#depo100', function () {
    $.post("http://codem-banking/codem:Deposit", JSON.stringify({ amount: 100 }), function (result) {
        // console.log(result)
        if (result) {
            notify("You deposit $100", "success")
        } else {
            notify("You don't have enough balance.", "error")
        }
    })
})


$(document).on('click', '#depo500', function () {
    $.post("http://codem-banking/codem:Deposit", JSON.stringify({ amount: 500 }), function (result) {
        if (result) {
            notify("You deposit $500", "success")
        } else {
            notify("You don't have enough balance.", "error")
        }
    })
})
$(document).on('click', '#depo1000', function () {
    $.post("http://codem-banking/codem:Deposit", JSON.stringify({ amount: 1000 }), function (result) {
        if (result) {
            notify("You deposit $1000", "success")
        } else {
            notify("You don't have enough balance.", "error")
        }
    })
})



$(document).on('click', '#100', function () {
    $.post("http://codem-banking/codem:WithDraw", JSON.stringify({ amount: 100 }), function (result) {
        // console.log(result)
        if (result) {
            notify("You withdraw $100", "success")
        } else {
            notify("You don't have enough balance.", "error")
        }
    })
})
$(document).on('click', '#500', function () {
    $.post("http://codem-banking/codem:WithDraw", JSON.stringify({ amount: 500 }), function (result) {

        if (result) {
            notify("You withdraw $500", "success")
        } else {
            notify("You don't have enough balance.", "error")
        }
    })
})
$(document).on('click', '#1000', function () {
    $.post("http://codem-banking/codem:WithDraw", JSON.stringify({ amount: 1000 }), function (result) {

        if (result) {
            notify("You withdraw $1000", "success")
        } else {
            notify("You don't have enough balance.", "error")
        }
    })
})

$(document).on('click', '#confirm-deposit', function () {
    const amount = $('#deposit-input').val()
    if (!isNaN(amount) && amount != '') {
        if (Number(amount) > 0) {

            $.post("http://codem-banking/codem:Deposit", JSON.stringify({ amount: Number(amount) }), function (result) {
                if (result) {
                    $('#deposit-input').val(0)

                    notify("You deposit ", amount, "success")
                } else {
                    notify("You don't have enough cash.", "error")
                }
            })

        } else {
            notify("Value must be higher than 0.", "error")

        }


    } else {
        notify("You need to enter a number.", "error")
    }

})


$(document).on('click', '#confirm-withdraw', function () {
    const amount = $('#withdraw-input').val()
    if (!isNaN(amount) && amount != '') {

        if (Number(amount) > 0) {

            $.post("http://codem-banking/codem:WithDraw", JSON.stringify({ amount: Number(amount) }), function (result) {
                if (result) {
                    $('#withdraw-input').val(0)

                    notify("You withdraw ", amount, "success")
                } else {
                    notify("You don't have enough balance.", "error")
                }
            })

        } else {
            notify("Value must be higher than 0.", "error")

        }


    } else {
        notify("You need to enter a number.", "error")
    }

})

$('#withdraw').click(function () {

    createDialog('withdraw')

})

$('#deposit').click(function () {

    createDialog('deposit')

})
$('#transfer').click(function () {

    createDialog('transfer')

})


$(document).on('click', '.close-dialog', function () {
    console.log('clicked')
    destroyDialog()

})


$(document).on('input', '#filter-input', function () {
    const val = $(this).val()
    createPlayers(val)


})



